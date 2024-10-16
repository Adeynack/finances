# frozen_string_literal: true

module Mutations
  class CreateBook < BaseMutation
    argument :book, Types::BookForCreateInputType, required: true

    field :book, Types::BookType, null: false

    def resolve(book:)
      new_book = authorize(Book).create!(owner: current_user, **book)

      {book: new_book}
    end
  end
end
