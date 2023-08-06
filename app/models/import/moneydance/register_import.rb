# frozen_string_literal: true
# typed: strict

module Import::Moneydance
  class RegisterImport
    extend T::Sig
    include Import::Moneydance::Utils

    sig do
      params(
        logger: Logger,
        md_items_by_type: T::Hash[String, T::Array[StringHash]],
        register_id_by_md_acctid: StringHash,
        register_id_by_md_old_id: StringHash,
        book: Book,
        md_currencies_by_id: T::Hash[String, StringHash]
      ).void
    end
    def initialize(logger:, md_items_by_type:, register_id_by_md_acctid:, register_id_by_md_old_id:, book:, md_currencies_by_id:)
      @logger = logger
      @md_items_by_type = md_items_by_type
      @register_id_by_md_acctid = register_id_by_md_acctid
      @register_id_by_md_old_id = register_id_by_md_old_id
      @book = book
      @md_currencies_by_id = md_currencies_by_id
    end

    sig { void }
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

    sig { params(accounts_to_import: T::Array[StringHash], md_accounts_by_parent_id: T::Hash[T.nilable(String), T::Array[StringHash]]).void }
    def import_account_batch(accounts_to_import, md_accounts_by_parent_id)
      types = accounts_to_import.map { |a| a.fetch("type") }.uniq.sort
      @logger.info "Importer MD accounts of type#{types.many? ? "s" : ""} #{types.join(", ")}"

      accounts_to_import.each do |md_account|
        import_account_recursively parent_register: nil, md_account:, md_accounts_by_parent_id:
      end
    end

    sig { params(md_account: StringHash).returns(T.class_of(Register)) }
    def register_class(md_account)
      case md_account["type"]
      when "a" then Asset
      when "b" then Bank
      when "c" then Card
      when "e" then Expense
      when "i" then Income
      when "l" then Liability
      when "o" then Loan
      when "v" then Investment
      else raise StandardError, "Unknown account type code \"#{md_account["type"]}\"."
      end
    end

    sig { params(md_account: StringHash, register: Register).void }
    def assign_account_information(md_account:, register:)
      case register
      when Bank then assign_bank_account_information(md_account:, register:)
      when Card then assign_card_account_information(md_account:, register:)
      when Investment then assign_investment_info(md_account:, register:)
      end
    end

    sig { params(parent_register: T.nilable(Register), md_account: StringHash, md_accounts_by_parent_id: T::Hash[T.nilable(String), T::Array[StringHash]]).void }
    def import_account_recursively(parent_register:, md_account:, md_accounts_by_parent_id:)
      @logger.info "Importing MD '#{md_account["type"]}' type account \"#{md_account["name"]}\" (ID \"#{md_account["id"]}\")"
      register = create_register(md_account, parent_register)
      @register_id_by_md_acctid[md_account.fetch("id")] = register.id
      @register_id_by_md_old_id[md_account.fetch("old_id")] = register.id
      register.import_origins.create! external_system: "moneydance", external_id: md_account.fetch("id")
      import_child_accounts(md_account, register, md_accounts_by_parent_id)
    end

    sig { params(md_account: StringHash, parent_register: T.nilable(Register)).returns(Register) }
    def create_register(md_account, parent_register)
      register = register_class(md_account).new(
        created_at: from_md_unix_date(md_account["creation_date"]),
        name: md_account["name"].presence&.strip,
        book: @book,
        parent: parent_register,
        starts_at: from_md_int_date(md_account["date_created"]),
        currency_iso_code: extract_currency_iso_code(md_account),
        initial_balance: md_account["sbal"]&.then(&:to_i),
        active: md_account["is_inactive"] != "y",
        default_category_id: extract_default_category_id(md_account),
        notes: md_account["comment"]&.strip.presence
      )
      assign_account_information(md_account:, register:)
      register.save!
      register
    end

    sig { params(md_account: StringHash).returns(T.nilable(String)) }
    def extract_currency_iso_code(md_account)
      md_account["currid"].presence&.then { |curr_id| @md_currencies_by_id[curr_id]&.[]("currid") }
    end

    sig { params(md_account: StringHash).returns(T.nilable(String)) }
    def extract_default_category_id(md_account)
      md_account["default_category"].presence&.then { |c| @register_id_by_md_old_id[c] }
    end

    sig { params(md_account: StringHash, parent_register: Register, md_accounts_by_parent_id: T::Hash[T.nilable(String), StringHash]).void }
    def import_child_accounts(md_account, parent_register, md_accounts_by_parent_id)
      md_accounts_by_parent_id[md_account["id"]].to_a.each do |child|
        import_account_recursively parent_register:, md_account: child, md_accounts_by_parent_id:
      end
    end

    sig { params(md_account: StringHash, register: Register).returns(NilClass) }
    def assign_bank_account_information(md_account:, register:)
      bank_account_number = md_account["bank_account_number"].presence
      register.assign_attributes(
        account_number: bank_account_number,
        iban: IBANTools::IBAN.valid?(bank_account_number) ? bank_account_number : nil
      )
    end

    sig { params(md_account: StringHash, register: Register).returns(NilClass) }
    def assign_card_account_information(md_account:, register:)
      register.assign_attributes(
        account_number: nil, # "bank_account_number" stores the card number in MD
        institution_name: md_account["bank_name"].presence,
        iban: nil, # "bank_account_number" stores the card number in MD
        interest_rate: md_account["apr"].presence&.to_f,
        credit_limit: md_account["credit_limit"].presence&.to_f&.then { |l| (l * 10).to_i },
        card_number: md_account["bank_account_number"].presence,
        expires_at: expiry_date(md_account["exp_year"], md_account["exp_month"])
      )
    end

    sig { params(md_account: StringHash, register: Register).returns(NilClass) }
    def assign_investment_info(md_account:, register:)
      register.assign_attributes(
        account_number: md_account["invst_account_number"]
      )
    end
  end
end
