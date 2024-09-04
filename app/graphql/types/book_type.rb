# frozen_string_literal: true

module Types
  class BookType < Types::BaseObject
    field :id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :name, String, null: false
    field :owner_id, ID, null: false
    field :owner, Types::UserType, null: false
    field :default_currency_iso_code, String, null: false
    field :import_origin, Types::ImportOriginType, null: true
  end
end
