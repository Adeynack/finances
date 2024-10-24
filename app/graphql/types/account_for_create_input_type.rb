# frozen_string_literal: true

module Types
  class AccountForCreateInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :import_origin, Types::ImportOriginInputType, required: false
    argument :name, String, required: true
    argument :type, Types::AccountTypeType, required: true
    argument :book_id, ID, required: true
    argument :parent_id, ID, required: false
    argument :starts_at, GraphQL::Types::ISO8601Date, required: false
    argument :expires_at, GraphQL::Types::ISO8601Date, required: false
    argument :currency_iso_code, String, required: true
    argument :notes, String, required: false
    argument :initial_balance, Integer, required: true
    argument :active, Boolean, required: true
    argument :default_category_id, ID, required: false
    argument :institution_name, String, required: false
    argument :account_number, String, required: false
    argument :iban, String, required: false
    argument :annual_interest_rate, Float, required: false
    argument :credit_limit, Integer, required: false
    argument :card_number, String, required: false
  end
end
