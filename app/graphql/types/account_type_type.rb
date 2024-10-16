# frozen_string_literal: true

module Types
  class AccountTypeType < Types::BaseEnum
    Register::ACCOUNT_TYPES.each do |t|
      value t
    end
  end
end
