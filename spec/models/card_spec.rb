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
#  starts_at            :date             not null                  Opening date of the register.
#  expires_at           :date                                       Optional expiration date of the register (ex: for a credit card).
#  currency_iso_code    :string(3)        not null
#  notes                :text
#  initial_balance      :bigint           default(0), not null
#  active               :boolean          default(TRUE), not null
#  default_category_id  :uuid             indexed                   The category automatically selected when entering a new exchange from this register.
#  institution_name     :string                                     Name of the institution (ex: bank) managing the registry (ex: credit card).
#  account_number       :string                                     Number by which the register is referred to (ex: bank account number).
#  iban                 :string                                     In the case the register is identified by an International Bank Account Number (IBAN).
#  annual_interest_rate :decimal(, )                                In the case the register is being charged interests, its rate per year (ex: credit card).
#  credit_limit         :bigint                                     In the case the register has a credit limit (ex: credit card, credit margin).
#  card_number          :string                                     In the case the register is linked to a card, its number (ex: a credit card).
#
require "rails_helper"

RSpec.describe Card do
  fixtures :all

  it "cannot create a card when IBAN is not valid" do
    card = Card.new name: "Visa", book: books(:joe), iban: "foo"
    expect(card.validate).to be_falsy
    expect(card.errors.details[:iban]).to eq [{error: :invalid}]
  end

  it "can create a card when IBAN is valid" do
    card = Card.new name: "Visa", book: books(:joe), iban: "SE35 5000 0000 0549 1000 0003", currency_iso_code: "EUR"
    expect(card.valid?).to be_truthy
  end

  it "cannot create any register with an invalid ISO currency code" do
    card = Card.new name: "Visa", book: books(:joe), currency_iso_code: "FOO"
    expect(card.validate).to be_falsy
    expect(card.errors.details[:currency_iso_code]).to eq [{error: :inclusion, value: "FOO"}]
  end
end
