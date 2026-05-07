# frozen_string_literal: true

module Types
  class ImportOriginInputType < Types::BaseInputObject
    argument :system, String, required: true
    argument :id, String, required: true

    def to_model
      ImportOrigin.new(external_system: self.system, external_id: id)
    end
  end
end
