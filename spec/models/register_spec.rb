# frozen_string_literal: true

# == Schema Information
#
# Table name: registers
#
#  id                   :uuid             not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  name                 :string           not null
#  type                 :enum             not null
#  book_id              :uuid             not null, indexed
#  parent_id            :uuid             indexed                   A null parent means it is a root register.
#  starts_at            :date                                       Opening date of the register (eg: for accounts, but not for categories).
#  expires_at           :date                                       Optional expiration date of the register (eg: for a credit card).
#  currency_iso_code    :string(3)        not null
#  notes                :text
#  initial_balance      :bigint           default(0), not null
#  active               :boolean          default(TRUE), not null
#  default_category_id  :uuid             indexed                   The category automatically selected when entering a new exchange from this register.
#  institution_name     :string                                     Name of the institution (eg: bank) managing the registry (eg: credit card).
#  account_number       :string                                     Number by which the register is referred to (eg: bank account number).
#  iban                 :string                                     In the case the register is identified by an International Bank Account Number (IBAN).
#  annual_interest_rate :decimal(, )                                In the case the register is being charged interests, its rate per year (eg: credit card).
#  credit_limit         :bigint                                     In the case the register has a credit limit (eg: credit card, credit margin).
#  card_number          :string                                     In the case the register is linked to a card, its number (eg: a credit card).
#
require "rails_helper"

RSpec.describe Register do
  fixtures :all

  describe "KNOWN_TYPES" do
    it "lists all types in DB enum" do
      db_register_types = Register.connection.execute("SELECT unnest(enum_range(NULL::register_type))").values.flatten
      expect(Register::KNOWN_TYPES).to match_array db_register_types
    end
  end

  describe "IBAN" do
    it "cannot create a card when IBAN is not valid" do
      r = Register.new name: "Visa", book: books(:joe), iban: "foo"
      expect(r.validate).to be_falsy
      expect(r.errors.details[:iban]).to eq [{error: :invalid}]
    end

    it "can create a card when IBAN is valid" do
      r = Register.new name: "Visa", book: books(:joe), iban: "SE35 5000 0000 0549 1000 0003", currency_iso_code: "EUR"
      expect(r.valid?).to be_truthy
    end

    it "cannot create any register with an invalid ISO currency code" do
      r = Register.new name: "Visa", book: books(:joe), currency_iso_code: "FOO"
      expect(r.validate).to be_falsy
      expect(r.errors.details[:currency_iso_code]).to eq [{error: :inclusion, value: "FOO"}]
    end
  end
end
