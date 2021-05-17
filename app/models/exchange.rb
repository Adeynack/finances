# frozen_string_literal: true

# == Schema Information
#
# Table name: exchanges
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  date        :date             not null, indexed
#  register_id :bigint           not null, indexed
#  cheque      :string
#  description :string           not null
#  memo        :text
#  status      :enum             default(NULL), not null
#
class Exchange < ApplicationRecord
  include Taggable
  include Importable

  belongs_to :register # origin of the exchange

  has_many :splits, dependent: :destroy

  enum status: [:uncleared, :reconciling, :cleared].index_with(:to_s)

  validates :description, presence: true
  validates :date, presence: true
end
