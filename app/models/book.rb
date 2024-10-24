# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                        :uuid             not null, primary key
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  name                      :string           not null
#  owner_id                  :uuid             not null, indexed
#  default_currency_iso_code :string(3)        not null
#
class Book < ApplicationRecord
  include Currencyable
  include Importable

  belongs_to :owner, class_name: "User"

  has_many :reminders, dependent: :destroy
  has_many :registers, dependent: :destroy
  has_many :exchanges, through: :registers
  has_many :accounts, -> { accounts }, class_name: "Register", dependent: false, inverse_of: :book
  has_many :categories, -> { categories }, class_name: "Register", dependent: false, inverse_of: :book
  has_many :users_where_default_book, class_name: "User", foreign_key: "default_book_id", dependent: :nullify, inverse_of: :default_book

  has_currency :default_currency

  validates :name, presence: true

  def debug_registers_tree
    result = []
    exchange_count_per_register_id = Exchange.group(:register_id).count
    split_count_per_register_id = Split.group(:register_id).count

    result << "Book '#{name}'"
    output_register = ->(level:, node:) do
      node.each do |r, children|
        result << [
          "#{"|   " * (level - 1)}|- #{r.type} '#{r.name}' (#{r.currency_iso_code})#{" ⛔️" unless r.active}",
          "#{exchange_count_per_register_id.fetch(r.id, 0) + split_count_per_register_id.fetch(r.id, 0)} exchanges (#{exchange_count_per_register_id.fetch(r.id, 0)} + #{split_count_per_register_id.fetch(r.id, 0)})"
        ].join(" // ")
        output_register.call(level: level + 1, node: children)
      end
    end
    output_register.call(level: 1, node: registers.hash_tree)

    result.join("\n")
  end

  def debug_reminders
    reminders.order(:title)
      .includes(:exchange_register, :reminder_splits)
      .map(&:debug)
      .join("\n")
  end

  def destroy!(fast: false)
    transaction do
      if fast
        execute_sql variables: {book_id: id}, query: <<~SQL
          DELETE FROM reminder_splits
          USING reminders
          WHERE reminder_splits.reminder_id = reminders.id
          	AND reminders.book_id = :book_id
        SQL
        execute_sql variables: {book_id: id}, query: <<~SQL
          DELETE FROM splits
          USING exchanges, registers
          WHERE splits.exchange_id = exchanges.id
          	AND exchanges.register_id = registers.id
          	AND registers.book_id = :book_id
        SQL
        execute_sql variables: {book_id: id}, query: <<~SQL
          DELETE FROM exchanges
          USING registers
          WHERE exchanges.register_id = registers.id
            AND registers.book_id = :book_id
        SQL
        reminders.delete_all
        registers.delete_all
      end

      super()
    end
  end
end
