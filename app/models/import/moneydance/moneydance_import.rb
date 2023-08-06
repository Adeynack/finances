# frozen_string_literal: true
# typed: strict

module Import::Moneydance
  class MoneydanceImport
    extend T::Sig
    include Import::Moneydance::Utils

    sig { returns(Logger) }
    attr_reader :logger

    sig { returns(T.untyped) }
    attr_reader :md_json

    sig { returns(Book) }
    attr_reader :book

    sig { returns(T::Hash[String, String]) }
    attr_reader :register_id_by_md_old_id

    sig { returns(T::Hash[String, String]) }
    attr_reader :register_id_by_md_acctid

    sig { params(logger: Logger, json_content: String).void }
    def initialize(logger:, json_content:)
      @logger = T.let(logger, Logger)

      @register_id_by_md_old_id = T.let({}, T::Hash[String, String])
      @register_id_by_md_acctid = T.let({}, T::Hash[String, String])
      @md_json = T.let(JSON.parse(json_content), T::Hash[String, T.untyped])
      @book = T.let(Book.new, Book)
    end

    sig { returns(T::Hash[String, T::Array[StringHash]]) }
    def md_items_by_type
      @md_items_by_type ||= T.let(
        md_json["all_items"].group_by { |i| i["obj_type"] },
        T.nilable(T::Hash[String, StringHash])
      )
    end

    sig { returns(T::Hash[String, StringHash]) }
    def md_currencies_by_old_id
      @md_currencies_by_old_id ||= T.let(
        (md_items_by_type["curr"] || []).index_by { |c| c["old_id"] },
        T.nilable(T::Hash[String, StringHash])
      )
    end

    sig { returns(T::Hash[String, StringHash]) }
    def md_currencies_by_id
      @md_currencies_by_id ||= T.let(
        (md_items_by_type["curr"] || []).index_by { |c| c["id"] },
        T.nilable(T::Hash[String, StringHash])
      )
    end

    sig { returns(T::Hash[String, StringHash]) }
    def md_accounts_by_old_id
      @md_accounts_by_old_id ||= T.let(
        (md_items_by_type["acct"] || []).index_by { |a| a["old_id"] },
        T.nilable(T::Hash[String, StringHash])
      )
    end

    sig { params(book_owner_email: String, default_currency: String, auto_delete_book: T::Boolean).void }
    def import(book_owner_email:, default_currency:, auto_delete_book: false)
      update_and_save_book(book_owner_email:, default_currency:, auto_delete_book:)
      RegisterImport.new(logger:, md_items_by_type:, register_id_by_md_acctid:, register_id_by_md_old_id:, book:, md_currencies_by_id:).import_accounts
      ReminderImport.new(logger:, book:, md_items_by_type:, register_id_by_md_acctid:).import_reminders
      ExchangeImport.new(logger:, md_items_by_type:, register_id_by_md_acctid:).import_exchanges
    end

    private

    sig { params(book_owner_email: String, default_currency: String, auto_delete_book: T::Boolean).void }
    def update_and_save_book(book_owner_email:, default_currency:, auto_delete_book:)
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
      book.update! name: book_name, owner: book_owner, default_currency_iso_code: default_currency
    end
  end
end
