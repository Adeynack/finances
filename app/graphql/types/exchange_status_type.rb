# frozen_string_literal: true

module Types
  class ExchangeStatusType < Types::BaseEnum
    ReminderSplit.statuses.each do |_, s|
      value s
    end
  end
end
