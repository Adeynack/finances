# frozen_string_literal: true

module Types
  class RegisterTypeType < Types::BaseEnum
    value "Bank"
    value "Card"
    value "Investment"
    value "Asset"
    value "Liability"
    value "Loan"
    value "Institution"
    value "Expense"
    value "Income"
  end
end
