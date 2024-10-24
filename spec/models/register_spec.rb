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

  describe "account?" do
    Register::ACCOUNT_TYPES.each do |type|
      it "is true for #{type}" do
        expect(Register.new(type:)).to be_account
      end
    end

    (Register::KNOWN_TYPES - Register::ACCOUNT_TYPES).each do |type|
      it "is false for #{type}" do
        expect(Register.new(type:)).not_to be_account
      end
    end
  end

  describe "category" do
    Register::CATEGORY_TYPES.each do |type|
      it "is true for #{type}" do
        expect(Register.new(type:)).to be_category
      end
    end

    (Register::KNOWN_TYPES - Register::CATEGORY_TYPES).each do |type|
      it "is false for #{type}" do
        expect(Register.new(type:)).not_to be_category
      end
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

  describe "#hierarchical_name" do
    before(:each) { Register.rebuild! }

    subject { register.hierarchical_name }

    context "when the register is at the root" do
      let(:register) { registers(:joe_first_bank) }

      it("is the name of the register itself") { should eq "First Bank" }
    end

    context "when the register is nested" do
      let(:register) { registers(:joe_fruits) }

      it("is the full path to the register, separated by a special character") do
        should eq "Food:Fruits"
      end
    end

    context "when the separator character is part of the name" do
      it "fails to validate" do
        register = registers(:joe_fruits)
        register.name = "Foo:Bar"
        expect(register.validate).to be false
        expect(register.errors.sole).to have_attributes(
          attribute: :name,
          type: :contains_separator_character
        )
      end
    end
  end
end
