# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :me, Types::UserType, null: true
    def me
      context[:current_api_session]&.user
    end

    field :books, [Types::BookType], null: false
    def books
      Book.all # todo: Secure this to only the books accessible by the logged in user.
    end
  end
end
