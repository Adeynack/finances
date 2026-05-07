# frozen_string_literal: true

module Types
  class ExchangeForCreateInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :created_at, GraphQL::Types::ISO8601DateTime, required: false
    argument :import_origin, Types::ImportOriginInputType, required: false
    argument :tags, [String], required: false
    argument :date, GraphQL::Types::ISO8601Date, required: true
    argument :register_id, ID, required: true
    argument :cheque, String, required: false
    argument :description, String, required: true
    argument :memo, String, required: false
    argument :status, Types::ExchangeStatusType, required: false
    argument :splits, [Types::SplitForCreateInputType], required: true
  end
end
