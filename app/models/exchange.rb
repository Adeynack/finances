# frozen_string_literal: true

# == Schema Information
#
# Table name: exchanges
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  date        :date             not null, indexed                Date the exchange appears in the book.
#  register_id :uuid             not null, indexed                From which register does the money come from.
#  cheque      :string                                            Cheque information.
#  description :string           not null                         Label of the exchange.
#  memo        :text                                              Detail about the exchange.
#  status      :enum             default("uncleared"), not null
#
class Exchange < ApplicationRecord
  include Taggable
  include Importable

  belongs_to :register # origin of the exchange
  has_one :book, through: :register

  has_many :splits, dependent: :destroy

  enum status: [:uncleared, :reconciling, :cleared].index_with(&:to_s)

  validates :description, presence: true
  validates :date, presence: true
end
