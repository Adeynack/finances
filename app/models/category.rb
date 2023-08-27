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
class Category < Register
  # self.abstract_class = true

  class << self
    extend T::Sig

    sig { returns(T::Array[T.class_of(Register)]) }
    def known_types
      @category_types ||= [Expense, Income].freeze
    end

    sig { returns(T::Array[String]) }
    def known_names
      @known_names ||= known_types.map(&:sti_name).freeze
    end
  end
end
