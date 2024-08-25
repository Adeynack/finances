# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id                   :uuid             not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  book_id              :uuid             not null, indexed
#  title                :string           not null
#  description          :text
#  mode                 :enum             default("manual"), not null
#  first_date           :date             not null                         From when to apply the reminder.
#  last_date            :date                                              Until when to apply the reminder (optional).
#  recurrence           :jsonb                                             Expressed as a 'Montrose::Recurrence' JSON. For one-shot reminders, `nil`, happening only on `first_date`.
#  last_commit_at       :date                                              Last time for which this reminder was committed. `nil` means it never was.
#  next_occurence_at    :date                                              Next time this reminder is scheduled for. Serves as a cache to quickly obtain all reminders that are due.
#  exchange_register_id :uuid             not null, indexed                From which register does the money come from.
#  exchange_description :string           not null                         Label of the exchange.
#  exchange_memo        :text                                              Detail about the exchange.
#  exchange_status      :enum             default("uncleared"), not null
#
require "rails_helper"

RSpec.describe Reminder do
  fixtures :all

  it "create a reminder with a recurence" do
    book = books(:joe)
    first_bank = registers(:joe_first_bank)
    reminder = book.reminders.create!(
      title: "Test 1",
      last_date: nil,
      exchange_description: "Reminder Exchange Template",
      exchange_register: first_bank,
      recurrence: Montrose.every(:year, mday: 7, month: :january)
    )
    expect(reminder.first_date).to eq Time.zone.today
    expect(reminder.next_occurence_at.year).to be >= Time.zone.today.year
    expect(reminder.next_occurence_at.month).to eq 1
    expect(reminder.next_occurence_at.day).to eq 7
  end

  it "create a reminder with no recurence" do
    book = books(:joe)
    first_bank = registers(:joe_first_bank)
    reminder = book.reminders.create!(
      title: "Test 1",
      last_date: nil,
      exchange_description: "Reminder Exchange Template",
      exchange_register: first_bank
    )
    # first_date defaults to today when not specified
    expect(reminder.first_date).to eq Time.zone.today
  end

  it "create a reminder passing IDs for register and book" do
    book = books(:joe)
    first_bank = registers(:joe_first_bank)
    Reminder.create!(
      book_id: book.id,
      exchange_register_id: first_bank.id,
      title: "Bleh",
      exchange_description: "Foo"
    )
  end

  it "fails if the register does not belong to the same book" do
    book = books(:joe)
    other_register = registers(:vlad_blood_bank)
    reminder = book.reminders.build(
      title: "Test 1",
      exchange_description: "Reminder Exchange Template",
      exchange_register: other_register
    )
    expect(reminder.validate).to be_falsy
    expect(reminder.errors.details[:exchange_register].pluck(:error)).to include :inclusion
  end

  it "fails if the last date is before first date" do
    reminder = books(:joe).reminders.build(
      exchange_register_id: registers(:joe_first_bank).id,
      title: "Bleh",
      exchange_description: "Foo",
      first_date: 2.days.from_now,
      last_date: 1.day.from_now
    )
    expect(reminder.validate).to be_falsy
    expect(reminder.errors.details[:last_date].pluck(:error)).to include :date_not_after
  end
end
