# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  book_id              :bigint           not null, indexed
#  title                :string           not null
#  description          :text
#  mode                 :enum             default("manual"), not null
#  first_date           :date             not null
#  last_date            :date
#  recurrence           :string
#  last_commit_at       :string
#  exchange_register_id :bigint           not null, indexed
#  exchange_description :string           not null
#  exchange_memo        :text
#  exchange_status      :enum             default("uncleared"), not null
#
require "test_helper"

class ReminderTest < ActiveSupport::TestCase
  test "create a reminder" do
    book = books(:joe)
    first_bank = registers(:first_bank)
    reminder = book.reminders.create!(
      title: "Test 1",
      last_date: nil,
      exchange_description: "Reminder Exchange Template",
      exchange_register: first_bank
    )
    # first_date defaults to today when not specified
    assert_equal Time.zone.today, reminder.first_date
  end

  test "create a reminder passing IDs for register and book" do
    book = books(:joe)
    first_bank = registers(:first_bank)
    Reminder.create!(
      book_id: book.id,
      exchange_register_id: first_bank.id,
      title: "Bleh",
      exchange_description: "Foo"
    )
  end

  test "fails if the register does not belong to the same book" do
    book = books(:joe)
    other_register = registers(:blood_bank)
    error = assert_raise(ActiveRecord::RecordInvalid) do
      book.reminders.create!(
        title: "Test 1",
        exchange_description: "Reminder Exchange Template",
        exchange_register: other_register
      )
    end
    assert_equal "Validation failed: Exchange register must belong to the same book as the reminder", error.message
  end
end
