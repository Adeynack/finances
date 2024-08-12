# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_book, mutation: Mutations::CreateBook
    field :destroy_book_fast, mutation: Mutations::DestroyBookFast
    field :log_in, mutation: Mutations::LogIn
    field :log_out, mutation: Mutations::LogOut
  end
end
