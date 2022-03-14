# frozen_string_literal: true

class CreateReminders < ActiveRecord::Migration[6.1]
  def change
    create_enum :reminder_mode, [:manual, :auto_commit, :auto_cancel]
    create_table :reminders do |t|
      t.timestamps
      t.references :book, foreign_key: true, null: false
      t.string :title, null: false
      t.text :description
      t.enum :mode, enum_type: :reminder_mode, null: false, default: :manual
      t.date :first_date, null: false, comment: "From when to apply the reminder."
      t.date :last_date, comment: "Until when to apply the reminder (optional)."
      t.jsonb :recurrence, comment: "Expressed as a 'Montrose::Recurrence' JSON. For one-shot reminders, `nil`, happening only on `first_date`."
      t.date :last_commit_at, comment: "Last time for which this reminder was committed. `nil` means it never was."
      t.date :next_occurence_at, comment: "Next time this reminder is scheduled for. Serves as a cache to quickly obtain all reminders that are due."
      # Exchange Template
      t.references :exchange_register, foreign_key: {to_table: :registers}, null: false, comment: "From which register does the money come from."
      t.string :exchange_description, null: false, comment: "Label of the exchange."
      t.text :exchange_memo, comment: "Detail about the exchange."
      t.enum :exchange_status, enum_type: :exchange_status, null: false, default: "uncleared"
    end
    create_table :reminder_splits do |t|
      t.timestamps
      t.references :reminder, foreign_key: true, null: false
      t.references :register, foreign_key: true, null: false, comment: "To which register is the money going to for this split."
      t.integer :amount, null: false
      t.integer :counterpart_amount, comment: "Amount in the destination register, if it differs from 'amount' (ex: an exchange rate applies)."
      t.text :memo, comment: "Detail about the exchange, to show in the destination register."
      t.enum :status, enum_type: :exchange_status, null: false, default: "uncleared"
    end
  end
end
