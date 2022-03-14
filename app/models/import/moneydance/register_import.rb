# frozen_string_literal: true

module Import::Moneydance::RegisterImport
  def import_accounts
    logger.info "Importing registers (MD accounts)"

    md_accounts_by_parent_id = md_items_by_type["acct"].group_by { |a| a["parentid"] || :root }
    root_accounts = md_accounts_by_parent_id[:root]
    raise StandardError, "More than one root account found." if root_accounts.length > 1

    root_account = root_accounts.first
    raise StandardError, "No root account found." if root_account.blank?

    first_level_accounts_per_type = md_accounts_by_parent_id[root_account["id"]].group_by { |a| a["type"] }
    batches = [
      first_level_accounts_per_type.delete("i"),
      first_level_accounts_per_type.delete("e"),
      first_level_accounts_per_type.values.flatten,
    ]
    batches.each { |accounts_to_import| import_account_batch(accounts_to_import, md_accounts_by_parent_id) }
  end

  def import_account_batch(accounts_to_import, md_accounts_by_parent_id)
    types = accounts_to_import.map { |a| a["type"] }.uniq!.sort!
    logger.info "Importer MD accounts of type#{types.many? ? "s" : ""} #{types.join(", ")}"

    accounts_to_import.each do |md_account|
      import_account_recursively parent_register: nil, md_account:, md_accounts_by_parent_id:
    end
  end

  def register_class_and_info_from_md_account(md_account)
    case md_account["type"]
    when "a" then [Asset, {}]
    when "b" then [Bank, extract_bank_account_info(md_account)]
    when "c" then [Card, extract_card_account_info(md_account)]
    when "e" then [Expense, {}]
    when "i" then [Income, {}]
    when "l" then [Liability, {}]
    when "o" then [Loan, {}]
    when "v" then [Investment, extract_investment_info(md_account)]
    else raise StandardError, "Unknown account type code \"#{md_account["type"]}\"."
    end
  end

  def import_account_recursively(parent_register:, md_account:, md_accounts_by_parent_id:)
    logger.info "Importing MD '#{md_account["type"]}' type account \"#{md_account["name"]}\" (ID \"#{md_account["id"]}\")"
    register = create_register(md_account, parent_register)
    register_id_by_md_acctid[md_account["id"]] = register.id
    register_id_by_md_old_id[md_account["old_id"]] = register.id
    register.import_origins.create! external_system: "moneydance", external_id: md_account["id"]
    import_child_accounts(md_account, register, md_accounts_by_parent_id)
  end

  def create_register(md_account, parent_register)
    register_class, account_info = register_class_and_info_from_md_account(md_account)
    attributes = account_info.merge(
      created_at: from_md_unix_date(md_account["creation_date"]),
      name: md_account["name"].presence&.strip,
      book:,
      parent: parent_register,
      starts_at: from_md_int_date(md_account["date_created"]),
      currency_iso_code: extract_currency_iso_code(md_account),
      initial_balance: md_account["sbal"]&.then(&:to_i),
      active: md_account["is_inactive"] != "y",
      default_category_id: extract_default_category_id(md_account),
      notes: md_account["comment"].presence&.strip
    )
    register_class.create! attributes
  end

  def extract_currency_iso_code(md_account)
    md_account["currid"].presence&.then { |curr_id| md_currencies_by_id[curr_id]["currid"] }
  end

  def extract_default_category_id(md_account)
    md_account["default_category"].presence&.then { |c| register_id_by_md_old_id[c] }
  end

  def import_child_accounts(md_account, parent_register, md_accounts_by_parent_id)
    (md_accounts_by_parent_id[md_account["id"]] || []).each do |child|
      import_account_recursively parent_register:, md_account: child, md_accounts_by_parent_id:
    end
  end

  def extract_bank_account_info(md_account)
    bank_account_number = md_account["bank_account_number"].presence
    {
      account_number: bank_account_number,
      iban: IBANTools::IBAN.valid?(bank_account_number) ? bank_account_number : nil
    }
  end

  def extract_card_account_info(md_account)
    {
      account_number: nil, # "bank_account_number" stores the card number in MD
      institution_name: md_account["bank_name"].presence,
      iban: nil, # "bank_account_number" stores the card number in MD
      interest_rate: md_account["apr"].presence&.to_f,
      credit_limit: md_account["credit_limit"].presence&.to_f&.then { |l| (l * 10).to_i },
      card_number: md_account["bank_account_number"].presence,
      expires_at: expiry_date(md_account["exp_year"], md_account["exp_month"])
    }
  end

  def extract_investment_info(md_account)
    {
      account_number: md_account["invst_account_number"]
    }
  end
end
