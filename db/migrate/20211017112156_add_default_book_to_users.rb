# frozen_string_literal: true

class AddDefaultBookToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :default_book, type: :uuid, foreign_key: {to_table: :books}, comment: "Last opened book."
  end
end
