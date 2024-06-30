# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :me, Types::UserType, null: true
    def me
      context[:current_api_session]&.user
    end
  end
end
