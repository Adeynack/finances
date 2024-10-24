# frozen_string_literal: true

module Types
  class SplitType < Types::BaseObject
    field :id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :exchange_id, ID, null: false
    field :register_id, ID, null: false
    field :amount, Integer, null: false
    field :counterpart_amount, Integer
    field :memo, String, null: true
    field :status, Types::ExchangeStatusType, null: false
    field :tags, [String], method: :tag_names
    field :import_origin, Types::ImportOriginType, null: true
  end
end
