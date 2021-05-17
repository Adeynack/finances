# frozen_string_literal: true

class CreateBookRoles < ActiveRecord::Migration[6.1]
  def change
    create_enum "book_role_name", [
      "admin",
      "writer",
      "reader",
    ]
    create_table :book_roles do |t|
      t.timestamps
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.enum :role, as: :book_role_name, null: false

      t.index [:book_id, :user_id, :role], unique: true
    end
  end
end
