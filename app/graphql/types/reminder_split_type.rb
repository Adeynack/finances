# frozen_string_literal: true

module Types
  class ReminderSplitType < Types::BaseObject
    field :id, ID, null: false
    field :register_id, ID, null: false
    field :amount, Integer, null: false
    field :counterpart_amount, Integer, null: true
    field :memo, String, null: true
    field :status, Types::ExchangeStatusType, null: false
    field :tags, [String], null: false, method: :tag_names
  end
end
