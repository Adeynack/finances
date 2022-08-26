# frozen_string_literal: true

# == Schema Information
#
# Table name: registers
#
#  id                  :uuid             not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  name                :string           not null
#  type                :enum             not null
#  book_id             :uuid             not null, indexed
#  parent_id           :uuid             indexed
#  starts_at           :date             not null
#  expires_at          :date
#  currency_iso_code   :string(3)        not null
#  notes               :text
#  initial_balance     :bigint           default(0), not null
#  active              :boolean          default(TRUE), not null
#  default_category_id :uuid             indexed
#  institution_name    :string
#  account_number      :string
#  iban                :string
#  interest_rate       :decimal(, )
#  credit_limit        :bigint
#  card_number         :string
#
class Expense < Category
end
