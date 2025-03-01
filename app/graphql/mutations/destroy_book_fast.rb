# frozen_string_literal: true

module Mutations
  class DestroyBookFast < BaseMutation
    argument :id, ID, required: true

    def resolve(id:)
      authorize(Book.find(id)).destroy!(fast: true)

      {}
    end
  end
end
