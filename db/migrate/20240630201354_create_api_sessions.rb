# frozen_string_literal: true

class CreateApiSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :api_sessions, id: :uuid do |t|
      t.timestamps
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :token, null: false, index: {unique: true}
    end
  end
end
