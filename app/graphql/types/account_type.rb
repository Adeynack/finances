# frozen_string_literal: true

module Types
  class AccountType < Types::BaseObject
    field :id, ID, null: false
    field :import_origin, Types::ImportOriginType, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :name, String, null: false
    field :type, Types::AccountTypeType, null: false
    field :book_id, ID, null: false
    field :parent_id, ID, null: true
    field :starts_at, GraphQL::Types::ISO8601Date, null: true
    field :expires_at, GraphQL::Types::ISO8601Date, null: true
    field :currency_iso_code, String, null: false
    field :notes, String, null: true
    field :initial_balance, Integer, null: false
    field :active, Boolean, null: false
    field :default_category_id, ID, null: true
    field :institution_name, String, null: true
    field :account_number, String, null: true
    field :iban, String, null: true
    field :annual_interest_rate, Float, null: true
    field :credit_limit, Integer, null: true
    field :card_number, String, null: true
  end
end
