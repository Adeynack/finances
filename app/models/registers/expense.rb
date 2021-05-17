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
#  currency_iso_code   :string(3)        not null
#  initial_balance     :integer          default(0), not null
#  active              :boolean          default(TRUE), not null
#  default_category_id :bigint           indexed
#  info                :jsonb
#
class Registers::Expense < Register
end
