# frozen_string_literal: true

class CreateRegisters < ActiveRecord::Migration[6.1]
  def change
    create_enum "register_type", [
      "Bank",
      "Card",
      "Investment",
      "Asset",
      "Liability",
      "Loan",
      "Institution",
      "Expense",
      "Income",
    ]
    create_table :registers do |t|
      t.timestamps
      t.string :name, null: false
      t.enum :type, as: :register_type, null: false
      t.references :book, null: false, foreign_key: true
      t.references :parent, foreign_key: { to_table: :registers }, comment: "A null parent means it is a root register."
      t.date :starts_at, null: false
      t.string :currency_iso_code, limit: 3, null: false
      t.integer :initial_balance, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.references :default_category, foreign_key: { to_table: :registers }, comment: "The category automatically selected when entering a new exchange from this register."
      t.jsonb :info
    end
  end
end
