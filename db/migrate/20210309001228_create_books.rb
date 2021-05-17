# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.timestamps
      t.string :name, null: false
      t.references :owner, foreign_key: { to_table: :users }, null: false
      t.string :default_currency_iso_code, limit: 3, null: false
    end
  end
end
