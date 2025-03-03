# frozen_string_literal: true

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
#  starts_at            :date
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

  self.inheritance_column = nil

  ACCOUNT_TYPES = ["Asset", "Bank", "Card", "Institution", "Investment", "Liability", "Loan"].freeze
  CATEGORY_TYPES = ["Expense", "Income"].freeze
  KNOWN_TYPES = (ACCOUNT_TYPES + CATEGORY_TYPES).freeze

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
  validate :validate_name_does_not_contain_separator_character
  validates :starts_at, date: true, presence: {if: :account?}
  validates :expires_at, date: true
  validates :currency_iso_code, presence: true
  validates :initial_balance, presence: true, numericality: {only_integer: true}
  validates :iban, iban: true
  validates :annual_interest_rate, numericality: {allow_nil: true}
  validates :credit_limit, numericality: {allow_nil: true, only_integer: true}

  scope :accounts, -> { where(type: ACCOUNT_TYPES) }
  scope :categories, -> { where(type: CATEGORY_TYPES) }
  scope :active, -> { where(active: true) }

  def account?
    ACCOUNT_TYPES.include?(type)
  end

  def category?
    CATEGORY_TYPES.include?(type)
  end

  HIERARCHICAL_NAME_SEPARATOR = ":"

  def hierarchical_name
    until_self = parent_id ? self_and_ancestors : [self]
    until_self.pluck(:name).reverse.join(HIERARCHICAL_NAME_SEPARATOR)
  end

  private

  def validate_name_does_not_contain_separator_character
    errors.add(:name, :contains_separator_character) if name.to_s.include?(HIERARCHICAL_NAME_SEPARATOR)
  end
end
