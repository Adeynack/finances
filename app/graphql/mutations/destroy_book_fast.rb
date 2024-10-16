# frozen_string_literal: true

module Mutations
  class DestroyBookFast < BaseMutation
    argument :id, ID, required: true

    def self.visible?(context)
      context[:current_api_session]&.user&.admin?
    end

    def resolve(id:)
      authorize(Book.find(id)).destroy!(fast: true)

      {}
    end
  end
end
