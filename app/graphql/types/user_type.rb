# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :email, String, null: false
    field :display_name, String, null: false
    field :default_book_id, ID, null: true
  end
end
