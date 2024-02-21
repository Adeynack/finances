# frozen_string_literal: true

# == Schema Information
#
# Table name: reminder_splits
#
#  id                 :uuid             not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  reminder_id        :uuid             not null, indexed
#  register_id        :uuid             not null, indexed
#  amount             :integer          not null
#  counterpart_amount :integer
#  memo               :text
#  status             :enum             default("uncleared"), not null
#
class ReminderSplit < ApplicationRecord
  include Taggable
  include Importable

  belongs_to :reminder
  belongs_to :register
end
