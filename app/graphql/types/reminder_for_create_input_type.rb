# frozen_string_literal: true

module Types
  class ReminderForCreateInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :import_origin, Types::ImportOriginInputType, required: false
    argument :book_id, ID, required: true
    argument :title, String, required: true
    argument :description, String, required: false
    argument :mode, ReminderModeType, required: true
    argument :first_date, GraphQL::Types::ISO8601Date, required: true
    argument :last_date, GraphQL::Types::ISO8601Date, required: false
    argument :last_commit_at, GraphQL::Types::ISO8601Date, required: false
    argument :recurrence, GraphQL::Types::JSON, required: true
    argument :exchange_register_id, ID, required: true
    argument :exchange_description, String, required: true
    argument :exchange_memo, String, required: false
    argument :exchange_status, Types::ExchangeStatusType, required: true
    argument :splits, [Types::ReminderSplitInputType], required: true
  end
end
