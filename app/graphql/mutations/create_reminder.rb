# frozen_string_literal: true

module Mutations
  class CreateReminder < BaseMutation
    argument :reminder, Types::ReminderForCreateInputType, required: true

    field :reminder, Types::ReminderType, null: false

    def resolve(reminder:)
      new_reminder = authorize Reminder.new(reminder.to_h.except(:import_origin, :splits))
      new_reminder.import_origin = reminder.import_origin&.to_model
      reminder.splits.each do |s|
        new_split = new_reminder.reminder_splits.new(s.to_h.except(:import_origin, :tags))
        new_split.import_origin = s.import_origin&.to_model
        s.tags&.each { new_split.tag(_1) }
      end
      new_reminder.save!
      {reminder: new_reminder}
    end
  end
end
