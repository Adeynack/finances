# frozen_string_literal: true

class CreateSplits < ActiveRecord::Migration[6.1]
  def change
    create_table :splits, id: :uuid do |t|
      t.timestamps
      t.references :exchange, type: :uuid, foreign_key: true, null: false
      t.references :register, type: :uuid, foreign_key: true, null: false, comment: "To which register is the money going to for this split."
      t.integer :position, null: false
      t.integer :amount, null: false
      t.integer :counterpart_amount, comment: "Amount in the destination register, if it differs from 'amount' (eg: an exchange rate applies)."
      t.text :memo, comment: "Detail about the exchange, to show in the destination register."
      t.enum :status, enum_type: :exchange_status, null: false, default: "uncleared"

      t.index [:exchange_id, :position], unique: true
    end
  end
end
