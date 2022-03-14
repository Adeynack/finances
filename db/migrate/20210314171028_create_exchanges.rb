# frozen_string_literal: true

class CreateExchanges < ActiveRecord::Migration[6.1]
  def change
    create_enum "exchange_status", ["uncleared", "reconciling", "cleared"]
    create_table :exchanges do |t|
      t.timestamps
      t.date :date, null: false, comment: "Date the exchange appears in the book."
      t.references :register, foreign_key: true, null: false, comment: "From which register does the money come from."
      t.string :cheque, comment: "Cheque information."
      t.string :description, null: false, comment: "Label of the exchange."
      t.text :memo, comment: "Detail about the exchange."
      t.enum :status, enum_type: :exchange_status, null: false, default: "uncleared"

      t.index :date
    end
  end
end
