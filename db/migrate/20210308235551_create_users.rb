# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  enable_extension "pgcrypto"

  def change
    create_table :users, id: :uuid do |t|
      t.timestamps null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.boolean :admin, null: false, default: false
      t.string :display_name, null: false
    end

    add_index :users, :email, unique: true
  end
end
