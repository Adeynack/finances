# frozen_string_literal: true

module Types
  class ReminderType < Types::BaseObject
    field :id, ID, null: false
    field :book_id, ID, null: false
    field :title, String, null: false
    field :description, String
    field :mode, Types::ReminderModeType, null: false
    field :first_date, GraphQL::Types::ISO8601Date, null: false
    field :last_date, GraphQL::Types::ISO8601Date
    field :recurrence, GraphQL::Types::JSON
    field :last_commit_at, GraphQL::Types::ISO8601Date
    field :next_occurence_at, GraphQL::Types::ISO8601Date
    field :exchange_register_id, ID, null: false
    field :exchange_description, String, null: false
    field :exchange_memo, String, null: true
    field :exchange_status, Types::ExchangeStatusType, null: false
    field :tags, [String], null: false, method: :tag_names
    field :splits, [Types::ReminderSplitType], null: false, method: :reminder_splits
  end
end
