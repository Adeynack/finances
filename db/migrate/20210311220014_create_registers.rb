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
      t.enum :type, enum_type: :register_type, null: false
      t.references :book, null: false, foreign_key: true
      t.references :parent, foreign_key: {to_table: :registers}, comment: "A null parent means it is a root register."
      t.date :starts_at, null: false, comment: "Opening date of the register."
      t.date :expires_at, comment: "Optional expiration date of the register (ex: for a credit card)."
      t.string :currency_iso_code, limit: 3, null: false
      t.text :notes
      t.bigint :initial_balance, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.references :default_category, foreign_key: {to_table: :registers}, comment: "The category automatically selected when entering a new exchange from this register."
      t.string :institution_name, comment: "Name of the institution (ex: bank) managing the registry (ex: credit card)."
      t.string :account_number, comment: "Number by which the register is referred to (ex: bank account number)."
      t.string :iban, comment: "In the case the register is identified by an International Bank Account Number (IBAN)."
      t.decimal :interest_rate, comment: "In the case the register is being charged interests, its rate (ex: credit card)."
      t.bigint :credit_limit, comment: "In the case the register has a credit limit (ex: credit card, credit margin)."
      t.string :card_number, comment: "In the case the register is linked to a card, its number (ex: a credit card)."
    end
  end
end
