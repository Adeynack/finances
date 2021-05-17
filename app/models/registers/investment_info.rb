# frozen_string_literal: true

module Registers
  class InvestmentInfo
    include JSONAttributable

    attribute :account_number, string: { allow_nil: true }
  end
end
