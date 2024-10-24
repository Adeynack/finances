# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                        :uuid             not null, primary key
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  name                      :string           not null
#  owner_id                  :uuid             not null, indexed
#  default_currency_iso_code :string(3)        not null
#
require "rails_helper"

RSpec.describe Book do
  fixtures :all
  before(:each) { ApplicationRecord.rebuild_all! }

  let(:book) { books(:joe) }

  describe "#debug_registers_tree" do
    subject { book.debug_registers_tree }

    it "returns the expected" do
      should eq <<~VALUE.chomp
        Book 'Joe's Book'
        |- Bank 'First Bank' (EUR) // 1 exchanges (1 + 0)
        |- Expense 'Food' (EUR) // 0 exchanges (0 + 0)
        |   |- Expense 'Fruits' (EUR) // 1 exchanges (0 + 1)
        |   |- Expense 'Meat' (EUR) // 0 exchanges (0 + 0)
        |- Expense 'Old Stuff' (EUR) ⛔️ // 0 exchanges (0 + 0)
      VALUE
    end
  end

  describe "#debug_reminders" do
    subject { book.debug_reminders }

    it "returns the expected" do
      should eq <<~VALUE.chomp
        Reminder: Monthly Fruits
          description:
          mode:           manual
          first date:     2020-01-01
          last date:
          recurrence:     {"every":"month","mday":[1]}
          last commit:
          next occurence:  (calculated: 2020-01-01 00:00:00 +0000)
          register:       First Bank
          splits:         1
            - register: Food:Fruits
              amount:   1000
              memo:
      VALUE
    end
  end

  describe "#destroy!" do
    let(:have_destroyed_all_sub_books_subresources) do
      change { book.registers.count }.to(0)
        .and change { book.reminders.count }.to(0)
        .and change { book.exchanges.count }.to(0)
        .and change { book.users_where_default_book.count }.to(0)
    end

    context "when the default action is called" do
      it "destroys the book and all of its associated ressources" do
        expect { book.destroy! }.to have_destroyed_all_sub_books_subresources
      end
    end

    context "when the `fast` action is called" do
      it "destroys the book and all of its associated ressources" do
        expect { book.destroy!(fast: true) }.to have_destroyed_all_sub_books_subresources
      end
    end
  end
end
