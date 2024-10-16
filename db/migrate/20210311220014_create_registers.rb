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
      "Income"
    ]
    create_table :registers, id: :uuid do |t|
      t.timestamps
      t.string :name, null: false
      t.column :type, :register_type, null: false
      t.references :book, type: :uuid, null: false, foreign_key: true
      t.references :parent, type: :uuid, foreign_key: {to_table: :registers}, comment: "A null parent means it is a root register."
      t.date :starts_at, comment: "Opening date of the register (eg: for accounts, but not for categories)."
      t.date :expires_at, comment: "Optional expiration date of the register (eg: for a credit card)."
      t.string :currency_iso_code, limit: 3, null: false
      t.text :notes
      t.bigint :initial_balance, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.references :default_category, type: :uuid, foreign_key: {to_table: :registers}, comment: "The category automatically selected when entering a new exchange from this register."
      t.string :institution_name, comment: "Name of the institution (eg: bank) managing the registry (eg: credit card)."
      t.string :account_number, comment: "Number by which the register is referred to (eg: bank account number)."
      t.string :iban, comment: "In the case the register is identified by an International Bank Account Number (IBAN)."
      t.decimal :annual_interest_rate, comment: "In the case the register is being charged interests, its rate per year (eg: credit card)."
      t.bigint :credit_limit, comment: "In the case the register has a credit limit (eg: credit card, credit margin)."
      t.string :card_number, comment: "In the case the register is linked to a card, its number (eg: a credit card)."
    end
  end
end
