# frozen_string_literal: true

require_relative "utils"

module MoneydanceImport
  class RegisterImport
    include MoneydanceImport::Utils

    def initialize(api_client:, logger:, md_items_by_type:, register_id_by_md_acctid:, register_id_by_md_old_id:, book:, md_currencies_by_id:)
      @api_client = api_client
      @logger = logger
      @md_items_by_type = md_items_by_type
      @register_id_by_md_acctid = register_id_by_md_acctid
      @register_id_by_md_old_id = register_id_by_md_old_id
      @book = book
      @md_currencies_by_id = md_currencies_by_id
    end

    def import_accounts
      @logger.info "Importing registers (MD accounts)"

      md_accounts_by_parent_id = @md_items_by_type["acct"].to_a.group_by { |a| a["parentid"] }
      root_accounts = md_accounts_by_parent_id[nil].to_a
      raise StandardError, "More than one root account found." if root_accounts.length > 1

      root_account = root_accounts.first
      raise StandardError, "No root account found." if root_account.blank?

      first_level_accounts_per_type = md_accounts_by_parent_id[root_account.fetch("id")].to_a.group_by { |a| a.fetch("type") }
      batches = [
        first_level_accounts_per_type.delete("i").to_a,
        first_level_accounts_per_type.delete("e").to_a,
        first_level_accounts_per_type.values.flatten
      ]
      batches.each { |accounts_to_import| import_account_batch(accounts_to_import, md_accounts_by_parent_id) }
    end

    private

    def import_account_batch(accounts_to_import, md_accounts_by_parent_id)
      types = accounts_to_import.map { |a| a.fetch("type") }.uniq!.sort
      @logger.info "Importer MD accounts of type#{types.many? ? "s" : ""} #{types.join(", ")}"

      accounts_to_import.each do |md_account|
        import_account_recursively parent_register: nil, md_account:, md_accounts_by_parent_id:
      end
    end

    def register_type(md_account)
      case md_account["type"]
      when "a" then "Asset"
      when "b" then "Bank"
      when "c" then "Card"
      when "e" then "Expense"
      when "i" then "Income"
      when "l" then "Liability"
      when "o" then "Loan"
      when "v" then "Investment"
      else raise StandardError, "Unknown account type code \"#{md_account["type"]}\"."
      end
    end

    def assign_account_information(md_account:, register:)
      case register["type"]
      when "Bank" then assign_bank_account_information(md_account:, register:)
      when "Card" then assign_card_account_information(md_account:, register:)
      when "Investment" then assign_investment_info(md_account:, register:)
      end
    end

    def import_account_recursively(parent_register:, md_account:, md_accounts_by_parent_id:)
      @logger.info "Importing MD '#{md_account["type"]}' type account \"#{md_account["name"]}\" (ID \"#{md_account["id"]}\")"
      register = create_register(md_account:, parent_register:)
      @register_id_by_md_acctid[md_account.fetch("id")] = register.id
      @register_id_by_md_old_id[md_account.fetch("old_id")] = register.id
      import_child_accounts(md_account, register, md_accounts_by_parent_id)
    end

    def create_register(md_account:, parent_register:)
      register = {
        type: register_type(md_account),
        name: md_account["name"].presence&.strip,
        book_id: @book.id,
        parent_id: parent_register&.id,
        starts_at: md_account["creation_date"]&.then { (_1.length == 8) ? from_md_int_date(_1) : from_md_unix_date(_1) },
        currency_iso_code: extract_currency_iso_code(md_account),
        initial_balance: md_account["sbal"]&.then(&:to_i),
        active: md_account["is_inactive"] != "y",
        default_category_id: extract_default_category_id(md_account),
        notes: md_account["comment"]&.strip.presence,
        # TODO: Get rid of the `import_origin` model completely, and save this information as a `meta` JSON field on the registry.
        import_origin: {system: "Moneydance", id: md_account.fetch("id")}
      }
      assign_account_information(md_account:, register:)
      @api_client.create_register(**register)
    end

    def extract_currency_iso_code(md_account)
      md_account["currid"].presence&.then { |curr_id| @md_currencies_by_id[curr_id]&.[]("currid") }
    end

    def extract_default_category_id(md_account)
      md_account["default_category"].presence&.then { |c| @register_id_by_md_old_id[c] }
    end

    def import_child_accounts(md_account, parent_register, md_accounts_by_parent_id)
      md_accounts_by_parent_id[md_account["id"]].to_a.each do |child|
        import_account_recursively parent_register:, md_account: child, md_accounts_by_parent_id:
      end
    end

    def assign_bank_account_information(md_account:, register:)
      bank_account_number = md_account["bank_account_number"].presence
      register.merge!(
        account_number: bank_account_number,
        iban: IBANTools::IBAN.valid?(bank_account_number) ? bank_account_number : nil
      )
    end

    def assign_card_account_information(md_account:, register:)
      register.merge!(
        account_number: nil, # "bank_account_number" stores the card number in MD
        institution_name: md_account["bank_name"].presence,
        iban: nil, # "bank_account_number" stores the card number in MD
        annual_interest_rate: md_account["apr"].presence&.to_f,
        credit_limit: md_account["credit_limit"].presence&.to_f&.then { |l| (l * 10).to_i },
        card_number: md_account["bank_account_number"].presence,
        expires_at: expiry_date(md_account["exp_year"], md_account["exp_month"])
      )
    end

    def assign_investment_info(md_account:, register:)
      register.merge!(
        account_number: md_account["invst_account_number"]
      )
    end
  end
end
