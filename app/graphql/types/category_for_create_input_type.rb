# frozen_string_literal: true

module Types
  class CategoryForCreateInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :import_origin, Types::ImportOriginInputType, required: false
    argument :name, String, required: true
    argument :income, Boolean, required: true,
      description: "Indicates if the category is income (true) or expense (false)."
    argument :book_id, ID, required: true
    argument :parent_id, ID, required: false
    argument :currency_iso_code, String, required: true
    argument :notes, String, required: false
    argument :active, Boolean, required: true
  end
end
