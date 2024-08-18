# frozen_string_literal: true

require_relative "utils"
require_relative "api_client"
require_relative "register_import"

module MoneydanceImport
  class MoneydanceImport
    include Utils

    attr_reader :logger
    attr_reader :md_json
    attr_reader :api_client
    attr_reader :default_currency
    attr_reader :auto_delete_book
    attr_reader :book
    attr_reader :register_id_by_md_old_id
    attr_reader :register_id_by_md_acctid

    def initialize(logger:, json_content:, api_client:, default_currency:, auto_delete_book: false)
      @logger = logger
      @register_id_by_md_old_id = {}
      @register_id_by_md_acctid = {}
      @md_json = JSON.parse(json_content)
      @api_client = api_client
      @default_currency = default_currency
      @auto_delete_book = auto_delete_book
    end

    def md_items_by_type
      @md_items_by_type ||= md_json["all_items"].to_a.group_by { |i| i["obj_type"] }
    end

    def md_currencies_by_old_id
      @md_currencies_by_old_id ||= md_items_by_type["curr"].to_a.index_by { |c| c["old_id"] }
    end

    def md_currencies_by_id
      @md_currencies_by_id ||= md_items_by_type["curr"].to_a.index_by { |c| c["id"] }
    end

    def md_accounts_by_old_id
      @md_accounts_by_old_id ||= md_items_by_type["acct"].to_a.index_by { |a| a["old_id"] }
    end

    def import!
      update_and_save_book!
      RegisterImport.new(api_client:, logger:, md_items_by_type:, register_id_by_md_acctid:, register_id_by_md_old_id:, book:, md_currencies_by_id:).import_accounts
      # ReminderImport.new(api_client:, logger:, book:, md_items_by_type:, register_id_by_md_acctid:).import_reminders
      # ExchangeImport.new(api_client:, logger:, md_items_by_type:, register_id_by_md_acctid:).import_exchanges
    end

    private

    def update_and_save_book!
      file_name = md_json["metadata"]["file_name"]
      export_date = md_json["metadata"]["export_date"].to_s
      book_name = "#{file_name} (#{export_date[0..3]}-#{export_date[4..5]}-#{export_date[6..7]})"
      book_candidate = api_client.list_books.find { _1.name == book_name }

      if book_candidate.present?
        logger.info "Book with name \"#{book_name}\" found"
        if auto_delete_book
          logger.info "Deleting book \"#{book_name}\""
          api_client.destroy_book_fast(id: book_candidate.id)
        elsif book_candidate.present?
          raise StandardError, "A book with name \"#{book_name}\" already exist. Can only import from scratch (book must not already exist)."
        end
      end

      logger.info "Create book with name \"#{book_name}\""
      @book = api_client.create_book(name: book_name, default_currency_iso_code: default_currency)
    end
  end
end
