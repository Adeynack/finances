# frozen_string_literal: true

module Types
  class CreateBookInputType < Types::BaseInputObject
    argument :id, ID, required: false
    auto_arguments Book,
      :name,
      :default_currency_iso_code
  end
end
