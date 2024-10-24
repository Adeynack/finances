# frozen_string_literal: true

# == Schema Information
#
# Table name: reminder_splits
#
#  id                 :uuid             not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  reminder_id        :uuid             not null, indexed, indexed => [position]
#  register_id        :uuid             not null, indexed                          To which register is the money going to for this split.
#  position           :integer          not null, indexed => [reminder_id]
#  amount             :integer          not null
#  counterpart_amount :integer                                                     Amount in the destination register, if it differs from 'amount' (eg: an exchange rate applies).
#  memo               :text                                                        Detail about the exchange, to show in the destination register.
#  status             :enum             default("uncleared"), not null
#
class ReminderSplit < ApplicationRecord
  include Taggable
  include Importable

  belongs_to :reminder
  has_one :book, through: :reminder
  belongs_to :register

  acts_as_list scope: :reminder

  enum status: Exchange.statuses

  def book
    super || reminder.book
  end
end
