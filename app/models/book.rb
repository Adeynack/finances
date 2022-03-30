# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                        :bigint           not null, primary key
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  name                      :string           not null
#  owner_id                  :bigint           not null, indexed
#  default_currency_iso_code :string(3)        not null
#
class Book < ApplicationRecord
  include Currencyable
  include Importable

  belongs_to :owner, class_name: "User"

  has_many :registers, dependent: :destroy
  has_many :accounts, -> { accounts }, class_name: "Register", dependent: false, inverse_of: :book
  has_many :categories, -> { categories }, class_name: "Register", dependent: false, inverse_of: :book
  has_many :exchanges, through: :registers
  has_many :reminders, dependent: :destroy

  has_currency :default_currency

  validates :name, presence: true

  def debug_registers_tree
    exchange_count_per_register_id = Exchange.group(:register_id).count
    split_count_per_register_id = Split.group(:register_id).count

    logger.info "Book '#{name}'"
    output_register = ->(level:, node:) do
      node.each do |r, children|
        logger.info [
          "#{"|   " * (level - 1)}|- #{r.type} '#{r.name}' (#{r.currency_iso_code})#{" ⛔️" unless r.active}",
          "#{exchange_count_per_register_id.fetch(r.id, 0) + split_count_per_register_id.fetch(r.id, 0)} exchanges (#{exchange_count_per_register_id.fetch(r.id, 0)} + #{split_count_per_register_id.fetch(r.id, 0)})"
        ].join(" // ")
        output_register.call(level: level + 1, node: children)
      end
    end
    output_register.call(level: 1, node: registers.hash_tree)
    nil
  end
  # rubocop:enable Metrics/AbcSize

  def debug_reminders
    reminders.order(:title).includes(:exchange_register, :reminder_splits).flat_map(&:debug).each { |line| logger.info(line) }
    nil
  end
end
