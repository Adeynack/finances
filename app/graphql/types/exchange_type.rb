# frozen_string_literal: true

module Types
  class ExchangeType < Types::BaseObject
    field :id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :date, GraphQL::Types::ISO8601Date, null: false
    field :register_id, ID, null: false
    field :cheque, String, null: true
    field :description, String, null: false
    field :memo, String, null: true
    field :status, Types::ExchangeStatusType, null: false
    field :tags, [String], method: :tag_names
    field :import_origin, Types::ImportOriginType, null: true
    field :splits, [SplitType], null: false
  end
end
