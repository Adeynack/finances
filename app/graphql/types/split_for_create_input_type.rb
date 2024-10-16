# frozen_string_literal: true

module Types
  class SplitForCreateInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :created_at, GraphQL::Types::ISO8601DateTime, required: false
    argument :import_origin, Types::ImportOriginInputType, required: false
    argument :tags, [String], required: false
    argument :register_id, ID, required: true
    argument :amount, Integer, required: true
    argument :counterpart_amount, Integer, required: true
    argument :memo, String, required: false
    argument :status, Types::ExchangeStatusType, required: false
  end
end
