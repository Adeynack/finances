# frozen_string_literal: true

namespace :data do
  namespace :import do
    desc "Import data from MoneyDance (raw JSON format)"
    task md: :environment do
      filename = ENV.fetch("MD_IMPORT_FILE", "./tmp/md.json")
      json_content = File.read filename

      book_owner_email = ENV.fetch("BOOK_OWNER_EMAIL", "joe@example.com")
      default_currency = ENV.fetch("DEFAULT_CURRENCY", "EUR")
      auto_delete_book = ENV.fetch("AUTO_DELETE_BOOK", "0") == "1"

      importer = Import::Moneydance::MoneydanceImport.new
      importer.import logger: Logger.new($stdout), json_content:, book_owner_email:, default_currency:, auto_delete_book:
    end
  end
end
