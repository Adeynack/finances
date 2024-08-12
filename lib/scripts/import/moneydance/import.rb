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
@api_email = ENV["FINANCES_API_EMAIL"]
@api_password = ENV["FINANCES_API_PASSWORD"]
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
    "-c CURRENCY_CODE",
    "--default-currency CURRENCU_CODE",
    "ISO Code (3 letters) of the default currency of the book to create."
  ) { @default_currency = _1 }
  opts.on(
    "-d",
    "--delete-book",
    "Delete the book if it already exists, before re-creating it and importing."
  ) { @auto_delete_book = true }
  opts.on(
    "-u URL",
    "--api-url URL",
    "URL of the Finances API."
  ) { @api_url = _1 }
  opts.on(
    "--api-email EMAIL",
    "The E-Mail to use to log in to the API. Alternatively, the environment FINANCES_API_EMAIL is used."
  ) { @api_email = _1 }
  opts.on(
    "--api-password PASSWORD",
    "The password to use to log in to the API. Alternatively, the environment FINANCES_API_PASSWORD is used."
  ) { @api_password = _1 }
end.parse!

{
  input_filepath: "Missing input file path (-i / --input-file).",
  default_currency: "Missing default currency code (-c / --default-currency).",
  api_url: "Missing the API URL (-u / --api-url).",
  api_email: "Missing the API E-Mail (--api-email or ENV 'FINANCES_API_EMAIL').",
  api_password: "Missing the API Password (--api-password or ENV 'FINANCES_API_PASSWORD')"
}.each do |variable, message|
  instance_variable_get(:"@#{variable}").present? || error(message)
end

json_content = File.read @input_filepath

MoneydanceImport::ApiClient.login_and_use(api_url: @api_url, api_email: @api_email, api_password: @api_password) do |api_client|
  MoneydanceImport::MoneydanceImport.new(
    logger: Logger.new($stdout),
    json_content:,
    api_client:,
    default_currency: @default_currency,
    auto_delete_book: @auto_delete_book
  ).import!
end
