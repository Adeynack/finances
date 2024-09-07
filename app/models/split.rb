# frozen_string_literal: true

# == Schema Information
#
# Table name: splits
#
#  id                 :uuid             not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  exchange_id        :uuid             not null, indexed, indexed => [position]
#  register_id        :uuid             not null, indexed                          To which register is the money going to for this split.
#  position           :integer          not null, indexed => [exchange_id]
#  amount             :integer          not null
#  counterpart_amount :integer                                                     Amount in the destination register, if it differs from 'amount' (eg: an exchange rate applies).
#  memo               :text                                                        Detail about the exchange, to show in the destination register.
#  status             :enum             default("uncleared"), not null
#
class Split < ApplicationRecord
  include Taggable
  include Importable

  belongs_to :exchange
  has_one :book, through: :exchange
  belongs_to :register # destination of the exchange's split

  acts_as_list scope: :exchange

  def book
    super || exchange.book
  end
end
