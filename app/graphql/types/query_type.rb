# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :me, Types::UserType, null: true
    def me
      current_user
    end

    field :books, Types::BookType.connection_type, null: false
    def books
      policy_scope(authorize(Book, :index))
    end
  end
end
