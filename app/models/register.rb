# frozen_string_literal: true

# == Schema Information
#
# Table name: registers
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  name                :string           not null
#  type                :enum             not null
#  book_id             :bigint           not null, indexed
#  parent_id           :bigint           indexed
#  starts_at           :date             not null
#  expires_at          :date
#  currency_iso_code   :string(3)        not null
#  notes               :text
#  initial_balance     :bigint           default(0), not null
#  active              :boolean          default(TRUE), not null
#  default_category_id :bigint           indexed
#  institution_name    :string
#  account_number      :string
#  iban                :string
#  interest_rate       :decimal(, )
#  credit_limit        :bigint
#  card_number         :string
#
class Register < ApplicationRecord
  include Currencyable
  include Taggable
  include Importable
  include AttributeStripping
  using ClassRefinements

  belongs_to :book
  has_closure_tree order: :name

  has_one :default_category, class_name: "Register", required: false, dependent: false

  has_many :reminders, dependent: :restrict_with_error, foreign_key: "exchange_register_id", inverse_of: :exchange_register

  # Exchanges originating from this register.
  # THIS REGISTER --> Exchange --> Splits --> Other Registers
  has_many :exchanges, dependent: :destroy

  # Splits pointing to this register. NOT splits of this register's exchanges.
  # Other Register --> Exchange --> Split --> THIS REGISTER
  has_many :splits, dependent: :destroy

  has_currency :currency

  validates :name, presence: true
  validates :starts_at, date: true
  validates :expires_at, date: true
  validates :initial_balance, presence: true, numericality: {only_integer: true}
  validates :iban, iban: true
  validates :interest_rate, numericality: {allow_nil: true}
  validates :credit_limit, numericality: {allow_nil: true, only_integer: true}

  scope :accounts, -> { where(type: Register.account_type_names) }
  scope :categories, -> { where(type: Register.category_type_names) }

  before_create do
    self.starts_at ||= Time.zone.today
    self.currency_iso_code ||= book.default_currency_iso_code
  end
end
