# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :log_in, mutation: Mutations::LogIn
    field :log_out, mutation: Mutations::LogOut
  end
end
