# frozen_string_literal: true

module Registers
  class CardInfo
    include JSONAttributable

    attribute :account_number, string: { allow_nil: true }
    attribute :iban, iban: { allow_nil: true }
    attribute :interest_rate, numericality: { allow_nil: true }
    attribute :credit_limit, numericality: { allow_nil: true }
    attribute :card_number, string: { allow_nil: true }
    attribute :expires_at, date: { allow_nil: true }
  end
end
