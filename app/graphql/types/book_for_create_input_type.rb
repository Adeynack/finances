# frozen_string_literal: true

module Types
  class BookForCreateInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :name, String, required: true
    argument :default_currency_iso_code, String, required: true
  end
end
