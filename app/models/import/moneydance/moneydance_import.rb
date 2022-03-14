# frozen_string_literal: true

class Import::Moneydance::MoneydanceImport
  include Import::Moneydance::Utils
  include Import::Moneydance::RegisterImport
  include Import::Moneydance::ReminderImport
  include Import::Moneydance::ExchangeImport

  attr_reader :logger
  attr_reader :md_json
  attr_reader :book
  attr_reader :register_id_by_md_old_id
  attr_reader :register_id_by_md_acctid

  def import(logger:, json_content:, book_owner_email:, default_currency:, auto_delete_book: false)
    @logger = logger

    @register_id_by_md_old_id = {}
    @register_id_by_md_acctid = {}
    @md_json = JSON.parse(json_content)

    set_book book_owner_email: book_owner_email, default_currency: default_currency, auto_delete_book: auto_delete_book
    import_accounts
    import_reminders
    import_exchanges
  end

  private

  def set_book(book_owner_email:, default_currency:, auto_delete_book:)
    raise StandardError, "Book is already initialized" if book.present?

    file_name = md_json["metadata"]["file_name"]
    export_date = md_json["metadata"]["export_date"].to_s
    book_name = "#{file_name} (#{export_date[0..3]}-#{export_date[4..5]}-#{export_date[6..7]})"

    book_candidate = Book.find_by(name: book_name)
    if book_candidate.present?
      logger.info "Book with name \"#{book_name}\" found"
      if auto_delete_book
        logger.info "Deleting book \"#{book_name}\""
        book_candidate.destroy!
      elsif book_candidate.present?
        raise StandardError, "A book with name \"#{book_name}\" already exist. Can only import from scratch (book must not already exist)."
      end
    end

    logger.info "Create book with name \"#{book_name}\" owned by user with email \"#{book_owner_email}\""
    book_owner = User.find_by email: book_owner_email
    @book = Book.create! name: book_name, owner: book_owner, default_currency_iso_code: default_currency
  end

  def md_items_by_type
    @md_items_by_type ||= md_json["all_items"].group_by { |i| i["obj_type"] }
  end

  def md_currencies_by_old_id
    @md_currencies_by_old_id ||= md_items_by_type["curr"].index_by { |c| c["old_id"] }
  end

  def md_currencies_by_id
    @md_currencies_by_id ||= md_items_by_type["curr"].index_by { |c| c["id"] }
  end

  def md_accounts_by_old_id
    @md_accounts_by_old_id ||= md_items_by_type["acct"].index_by { |a| a["old_id"] }
  end
end
