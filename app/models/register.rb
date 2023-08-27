# frozen_string_literal: true
# typed: true

# == Schema Information
#
# Table name: registers
#
#  id                   :uuid             not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  name                 :string           not null
#  type                 :enum             not null
#  book_id              :uuid             not null, indexed
#  parent_id            :uuid             indexed
#  starts_at            :date             not null
#  expires_at           :date
#  currency_iso_code    :string(3)        not null
#  notes                :text
#  initial_balance      :bigint           default(0), not null
#  active               :boolean          default(TRUE), not null
#  default_category_id  :uuid             indexed
#  institution_name     :string
#  account_number       :string
#  iban                 :string
#  annual_interest_rate :decimal(, )
#  credit_limit         :bigint
#  card_number          :string
#
class Register < ApplicationRecord
  include Currencyable
  include Taggable
  include Importable
  include AttributeStripping

  belongs_to :book, optional: false
  has_closure_tree order: :name, dependent: :destroy

  has_one :default_category, class_name: "Register", required: false, dependent: false, inverse_of: :registers_where_default_category
  has_many :registers_where_default_category, class_name: "Register", foreign_key: "default_category_id", dependent: :nullify, inverse_of: :default_category

  has_many :reminders, dependent: :restrict_with_error, foreign_key: "exchange_register_id", inverse_of: :exchange_register

  # Exchanges originating from this register.
  # THIS REGISTER --> Exchange --> Splits --> Other Registers
  has_many :exchanges, dependent: :destroy

  # Splits pointing to this register. NOT splits of this register's exchanges.
  # Other Register --> Exchange --> Split --> THIS REGISTER
  has_many :splits, dependent: :destroy

  # Splits from reminders pointing to this register.
  has_many :reminder_splits, dependent: :restrict_with_exception

  has_currency :currency

  validates :name, presence: true
  validates :starts_at, date: true
  validates :expires_at, date: true
  validates :initial_balance, presence: true, numericality: {only_integer: true}
  validates :iban, iban: true
  validates :annual_interest_rate, numericality: {allow_nil: true}
  validates :credit_limit, numericality: {allow_nil: true, only_integer: true}

  scope :accounts, -> { where(type: Account.known_names) }
  scope :categories, -> { where(type: Category.known_names) }
  scope :active, -> { where(active: true) }

  before_create do
    T.unsafe(self).starts_at ||= Time.zone.today
    T.unsafe(self).currency_iso_code ||= book&.default_currency_iso_code
  end

  def hierarchical_name
    self_and_ancestors.pluck(:name).reverse.join(" > ")
  end
end
