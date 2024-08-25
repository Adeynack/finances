# frozen_string_literal: true

module Types
  class ReminderModeType < Types::BaseEnum
    Reminder.modes.each do |_, m|
      value m
    end
  end
end
