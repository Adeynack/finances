# frozen_string_literal: true

module Types
  class ImportOriginType < Types::BaseObject
    field :system, String, null: false
    field :id, String, null: false
  end
end
