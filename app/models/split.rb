# frozen_string_literal: true
# typed: true

# == Schema Information
#
# Table name: splits
#
#  id                 :uuid             not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  exchange_id        :uuid             not null, indexed
#  register_id        :uuid             not null, indexed
#  amount             :integer          not null
#  counterpart_amount :integer
#  memo               :text
#  status             :enum             default("uncleared"), not null
#
class Split < ApplicationRecord
  include Taggable
  include Importable

  belongs_to :exchange
  belongs_to :register # destination of the exchange's split
end
