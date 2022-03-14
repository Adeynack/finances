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
class Category < Register
  # self.abstract_class = true

  def known_types
    @category_types ||= find_child_from_files(namespace: nil).freeze
  end

  def known_names
    @known_names ||= known_types.map(&:sti_name).freeze
  end
end
