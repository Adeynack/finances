# frozen_string_literal: true

module Mutations
  class CreateBook < BaseMutation
    argument :name, String, required: true
    argument :default_currency_iso_code, String, required: true

    field :book, Types::BookType, null: false

    def resolve(name:, default_currency_iso_code:)
      book = authorize(Book).create!(
        owner: current_user,
        name:, default_currency_iso_code:
      )

      {book:}
    end
  end
end
