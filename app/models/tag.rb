# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string           not null, indexed
#
class Tag < ApplicationRecord
  include Importable

  has_many :taggings, dependent: :delete_all
  has_many :subjects, through: :taggings
end
