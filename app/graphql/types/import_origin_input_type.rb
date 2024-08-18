# frozen_string_literal: true

module Types
  class ImportOriginInputType < Types::BaseInputObject
    argument :system, String, required: true
    argument :id, String, required: true
  end
end
