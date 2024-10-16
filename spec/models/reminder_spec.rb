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
  before(:each) { ApplicationRecord.rebuild_all! }

  describe "creaating a new reminder" do
    it "creates it with a recurence" do
      travel_to "2024-09-03"
      book = books(:joe)
      first_bank = registers(:joe_first_bank)
      reminder = book.reminders.create!(
        title: "Test 1",
        last_date: nil,
        exchange_description: "Reminder Exchange Template",
        exchange_register: first_bank,
        recurrence: Montrose.every(:year, mday: 7, month: :january)
      )
      expect(reminder.first_date).to eq "2024-09-03".to_date
      expect(reminder.next_occurence_at).to eq "2025-01-07".to_date
    end

    it "creates it with no recurence" do
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

    it "creates it passing IDs for register and book" do
      book = books(:joe)
      first_bank = registers(:joe_first_bank)
      reminder = Reminder.create!(
        book_id: book.id,
        exchange_register_id: first_bank.id,
        title: "Bleh",
        exchange_description: "Foo"
      )
      expect(reminder.book).to eq book
      expect(reminder.exchange_register).to eq first_bank
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

  describe "#calculate_next_occurence_at" do
    let(:reminder) { Reminder.new(first_date:, last_date:, last_commit_at:, recurrence:) }

    subject { reminder.calculate_next_occurence_at&.to_date }

    before { travel_to today }

    context "when today is 2024-09-03" do
      let(:today) { "2024-09-03" }

      context "when recurrence is every 1st of the month" do
        let(:recurrence) { Montrose.every(:month, mday: 1) }

        context "when first date is in the past" do
          let(:first_date) { "2024-01-01".to_date }

          context "when last date is not set" do
            let(:last_date) { nil }

            context "when last commited date is nil" do
              let(:last_commit_at) { nil }

              it("is the start date") { should eq first_date }
            end

            context "when last commited date is more than one recurrence in the past" do
              let(:last_commit_at) { "2024-05-01".to_date }

              it("is at the next occurence (1 month after last commit)") { should eq "2024-06-01".to_date }
            end

            context "when last commited date is today" do
              let(:last_commit_at) { "2024-09-03" }

              it("is the 1st of next month") { should eq "2024-10-01".to_date }
            end

            context "when last commited date is in the future" do
              let(:last_commit_at) { "2027-03-08" }

              it("the 1st of the next month after last commit") { should eq "2027-04-01".to_date }
            end
          end

          context "when last date is in the past" do
            let(:last_date) { "2024-04-01" }

            context "when last commit is nil" do
              let(:last_commit_at) { nil }

              it("is the start date") { should eq first_date }
            end

            context "when last commit between first and last date" do
              let(:last_commit_at) { "2024-02-01" }

              it("is the start date") { should eq "2024-03-01".to_date }
            end

            context "when last commit is on the last date" do
              let(:last_commit_at) { "2024-04-01" }

              it("is the start date") { should be_nil }
            end

            context "when last commit is after the last date" do
              let(:last_commit_at) { "2024-05-01" }

              it("is the start date") { should be_nil }
            end
          end
        end
      end
    end
  end

  describe "#debug" do
    before { travel_to "2024-09-03" }

    let(:reminder) do
      Reminder.create!(
        book: books(:joe),
        recurrence: Montrose.every(:month, mday: 15),
        title: "Text",
        exchange_register: registers(:joe_first_bank),
        exchange_description: "Test",
        reminder_splits:
      )
    end

    subject { reminder.debug }

    context "with splits" do
      let(:reminder_splits) do
        [
          ReminderSplit.new(register: registers(:joe_fruits), amount: 100),
          ReminderSplit.new(register: registers(:joe_meat), amount: 100)
        ]
      end

      it("returns the expected") do
        should eq <<~VALUE.chomp
          Reminder: Text
            description:
            mode:           manual
            first date:     2024-09-03
            last date:
            recurrence:     {"every":"month","mday":[15]}
            last commit:
            next occurence: 2024-09-15 (calculated: 2024-09-15 00:00:00 +0000)
            register:       First Bank
            splits:         2
              - register: Food:Fruits
                amount:   100
                memo:
              - register: Food:Meat
                amount:   100
                memo:
        VALUE
      end
    end

    context "without splits" do
      let(:reminder_splits) { [] }

      it("returns the expected") do
        should eq <<~VALUE.chomp
          Reminder: Text
            description:
            mode:           manual
            first date:     2024-09-03
            last date:
            recurrence:     {"every":"month","mday":[15]}
            last commit:
            next occurence: 2024-09-15 (calculated: 2024-09-15 00:00:00 +0000)
            register:       First Bank
            splits:         0
        VALUE
      end
    end
  end

  describe "#validate" do
    let(:reminder) do
      Reminder.new(
        book:,
        recurrence: Montrose.every(:month, mday: 15),
        title: "Text",
        exchange_register: registers(:joe_first_bank),
        exchange_description: "Test",
        reminder_splits: [
          ReminderSplit.new(register: registers(:joe_fruits), amount: 100),
          ReminderSplit.new(register: registers(:joe_meat), amount: 100)
        ]
      )
    end

    subject { reminder.tap(&:validate).errors.as_json }

    context "when book is nil" do
      let(:book) { nil }

      it("reports book missing") { should eq({book: ["must exist"]}) }
      it("does not report errors on exchange register") { should_not have_key :exchange_register }
    end
  end
end
