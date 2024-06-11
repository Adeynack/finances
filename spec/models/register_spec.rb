# frozen_string_literal: true

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
