# frozen_string_literal: true

require "optparse"
require "active_support"
require "active_support/all"

require_relative "moneydance_import"

def error(title)
  warn title
  exit 1
end

@input_filepath = nil
@api_token = nil
@default_currency = nil
@auto_delete_book = false

OptionParser.new do |opts|
  opts.banner = "Usage: ruby import.rb [options]"
  opts.on(
    "-i FILEPATH",
    "--input-file FILEPATH",
    "Path to the Moneydance exported JSON file to import"
  ) { @input_filepath = _1 }
  opts.on(
    "-t TOKEN",
    "--api-token TOKEN",
    "User API Token, including the `Bearer` prefix."
  ) { @api_token = _1 }
  opts.on(
    "-c CURRENCY_CODE",
    "--default-currency CURRENCU_CODE",
    "ISO Code (3 letters) of the default currency of the book to create."
  ) { @default_currency = _1 }
  opts.on(
    "-d",
    "--delete-book",
    "Delete the book if it already exists, before re-creating it and importing."
  ) { @auto_delete_book = true }
end.parse!

@input_filepath.present? || error("Missing input file path (-i / --input-file).")
@api_token.present? || error("Missing API token (-t / --api-token).")
@default_currency.present? || error("Missing default currency code (-c / --default-currency).")

json_content = File.read @input_filepath

importer = Import::Moneydance::MoneydanceImport.new(logger: Logger.new($stdout), json_content:)
importer.import(api_token:, default_currency:, auto_delete_book:)
