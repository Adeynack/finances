# frozen_string_literal: true

module Registers
  class BankInfo
    include JSONAttributable

    attribute :account_number, string: { allow_nil: true }
    attribute :iban, iban: { allow_nil: true }
  end
end
