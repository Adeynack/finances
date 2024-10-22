# frozen_string_literal: true

module Mutations
  class CreateCategory < BaseMutation
    argument :category, Types::CategoryForCreateInputType, required: true

    field :category, Types::CategoryType, null: false

    def resolve(category:)
      category_attr = category.to_h
      import_origin = category_attr.delete(:import_origin)
      type = category_attr.delete(:income) ? "Income" : "Expense"
      new_category = Register.new(category_attr.merge(type:))
      authorize(new_category).save!
      new_category.create_import_origin! external_id: import_origin[:id], external_system: import_origin[:system] if import_origin
      {category: new_category}
    end
  end
end
