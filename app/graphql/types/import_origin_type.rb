# frozen_string_literal: true

module Types
  class ImportOriginType < Types::BaseObject
    field :system, String, null: false, method: :external_system
    field :id, String, null: false, method: :external_id
  end
end
