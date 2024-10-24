# frozen_string_literal: true

module Types
  class CategoryType < Types::BaseObject
    field :id, ID, null: false
    field :import_origin, Types::ImportOriginType, null: true
    field :name, String, null: false
    field :income, Boolean, null: false, description: "Indicates if the category is income (true) or expense (false)."
    field :book_id, ID, null: false
    field :parent_id, ID, null: true
    field :currency_iso_code, String, null: false
    field :notes, String, null: true
    field :active, Boolean, null: false

    # TODO: Change `income` by `Type`, just like `AccountType`
    def income
      object.type == "Income"
    end
  end
end
