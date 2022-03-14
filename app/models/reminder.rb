# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  book_id              :bigint           not null, indexed
#  title                :string           not null
#  description          :text
#  mode                 :enum             default("manual"), not null
#  first_date           :date             not null
#  last_date            :date
#  recurrence           :jsonb
#  last_commit_at       :date
#  next_occurence_at    :date
#  exchange_register_id :bigint           not null, indexed
#  exchange_description :string           not null
#  exchange_memo        :text
#  exchange_status      :enum             default("uncleared"), not null
#
class Reminder < ApplicationRecord
  include Taggable
  include Importable

  belongs_to :book
  belongs_to :exchange_register, class_name: "Register"

  has_many :reminder_splits, dependent: :destroy

  enum mode: [:manual, :auto_commit, :auto_cancel].index_with(&:to_s)
  serialize :recurrence, MontroseJSONSerializer

  validates :title, presence: true
  validates :first_date, presence: true
  validate :validate_last_date_after_first_date
  validate :validate_exchange_register_on_same_book_as_reminder
  validates :exchange_description, presence: true

  before_validation do
    self.first_date = Time.zone.today if first_date.blank?
    self.next_occurence_at = calculate_next_occurence_at
  end

  def calculate_next_occurence_at
    return nil if last_date&.past?
    return first_date unless recurrence

    starting_at = [last_commit_at, first_date].compact.max if last_commit_at
    starting_at ||= [Time.zone.today, starting_at].compact.max
    recurrence.starting(starting_at).first
  end

  def debug
    [
      "Reminder: #{title}",
      "  description: #{description}",
      "  mode:        #{mode}",
      "  first date:  #{first_date}",
      "  last date:   #{last_date}",
      "  recurrence:  #{recurrence.to_json}",
      "  register:    #{exchange_register.ancestry_path.join(" / ")}",
      reminder_splits.map do |split|
        [
          "    - register: #{split.register.ancestry_path.join(" / ")}",
          "      amount:   #{split.amount}",
          "      memo:     #{split.memo}",
        ]
      end,
      "",
    ].flatten
  end

  private

  def validate_last_date_after_first_date
    errors.add :last_date, "must be after first date" if last_date.present? && first_date >= last_date
  end

  def validate_exchange_register_on_same_book_as_reminder
    return if exchange_register_id.blank?

    register = exchange_register || Register.find(exchange_register_id)
    errors.add :exchange_register, "must belong to the same book as the reminder" if register.present? && register.book_id != book_id
  end
end
