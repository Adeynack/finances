# frozen_string_literal: true

module Types
  class ReminderSplitInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :import_origin, Types::ImportOriginInputType, required: false
    argument :register_id, ID, required: true
    argument :amount, Integer, required: true
    argument :counterpart_amount, Integer, required: false
    argument :memo, String, required: false
    argument :status, Types::ExchangeStatusType, required: true
    argument :tags, [String], required: false
  end
end
