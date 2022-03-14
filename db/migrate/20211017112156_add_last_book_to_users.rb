# frozen_string_literal: true

class AddLastBookToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :last_book, foreign_key: {to_table: :books}, comment: "Last opened book."
  end
end
