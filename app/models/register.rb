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
#  parent_id            :uuid             indexed                   A null parent means it is a root register.
#  starts_at            :date                                       Opening date of the register (eg: for accounts, but not for categories).
#  expires_at           :date                                       Optional expiration date of the register (eg: for a credit card).
#  currency_iso_code    :string(3)        not null
#  notes                :text
#  initial_balance      :bigint           default(0), not null
#  active               :boolean          default(TRUE), not null
#  default_category_id  :uuid             indexed                   The category automatically selected when entering a new exchange from this register.
#  institution_name     :string                                     Name of the institution (eg: bank) managing the registry (eg: credit card).
#  account_number       :string                                     Number by which the register is referred to (eg: bank account number).
#  iban                 :string                                     In the case the register is identified by an International Bank Account Number (IBAN).
#  annual_interest_rate :decimal(, )                                In the case the register is being charged interests, its rate per year (eg: credit card).
#  credit_limit         :bigint                                     In the case the register has a credit limit (eg: credit card, credit margin).
#  card_number          :string                                     In the case the register is linked to a card, its number (eg: a credit card).
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
  validates :starts_at, date: true
  validates :expires_at, date: true
  validates :initial_balance, presence: true, numericality: {only_integer: true}
  validates :iban, iban: true
  validates :annual_interest_rate, numericality: {allow_nil: true}
  validates :credit_limit, numericality: {allow_nil: true, only_integer: true}

  scope :accounts, -> { where(type: ACCOUNT_TYPES) }
  scope :categories, -> { where(type: CATEGORY_TYPES) }
  scope :active, -> { where(active: true) }

  before_create do
    self.starts_at ||= Time.zone.today
    self.currency_iso_code ||= book&.default_currency_iso_code
  end

  def hierarchical_name
    self_and_ancestors.pluck(:name).reverse.join(" > ")
  end
end
