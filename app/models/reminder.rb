# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id                   :uuid             not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  book_id              :uuid             not null, indexed
#  title                :string           not null
#  description          :text
#  mode                 :enum             default("manual"), not null
#  first_date           :date             not null                         From when to apply the reminder.
#  last_date            :date                                              Until when to apply the reminder (optional).
#  recurrence           :jsonb                                             Expressed as a 'Montrose::Recurrence' JSON. For one-shot reminders, `nil`, happening only on `first_date`.
#  last_commit_at       :date                                              Last time for which this reminder was committed. `nil` means it never was.
#  next_occurence_at    :date                                              Next time this reminder is scheduled for. Serves as a cache to quickly obtain all reminders that are due.
#  exchange_register_id :uuid             not null, indexed                From which register does the money come from.
#  exchange_description :string           not null                         Label of the exchange.
#  exchange_memo        :text                                              Detail about the exchange.
#  exchange_status      :enum             default("uncleared"), not null
#
class Reminder < ApplicationRecord
  include Taggable
  include Importable

  belongs_to :book
  belongs_to :exchange_register, class_name: "Register"

  has_many :reminder_splits, dependent: :destroy

  enum mode: [:manual, :auto_commit, :auto_cancel].index_with(&:to_s)
  serialize :recurrence, coder: MontroseJSONSerializer

  validates :title, presence: true
  validates :first_date, presence: true
  validates :last_date, date: {after: :first_date}
  validates :exchange_register, inclusion: {if: :book, in: ->(r) { r.book.registers.to_a }, message: :must_belong_to_reminder_book}
  validates :exchange_description, presence: true

  before_validation do
    self.first_date = Time.zone.today if first_date.blank?
    self.next_occurence_at = calculate_next_occurence_at
  end

  def calculate_next_occurence_at
    return first_date unless recurrence

    next_occurence = if last_commit_at&.after?(first_date)
      # this reminder was last comitted after its first date
      # next occurence after last_commit_at, excluding today
      candidates = recurrence.starting(last_commit_at).first(2)
      (candidates[0] == last_commit_at) ? candidates[1] : candidates[0]
    else
      # last_commit_at is nil, or before first_date
      # first ocurence starting first_date
      recurrence.starting(first_date).first
    end

    # Make sure we do not schedule this reminder after its last date.
    return nil if last_date && next_occurence.after?(last_date)

    next_occurence
  end

  def debug
    [
      "Reminder: #{title}",
      "  description:    #{description}",
      "  mode:           #{mode}",
      "  first date:     #{first_date}",
      "  last date:      #{last_date}",
      "  recurrence:     #{recurrence.to_json}",
      "  last commit:    #{last_commit_at}",
      "  next occurence: #{next_occurence_at} (calculated: #{calculate_next_occurence_at})",
      "  register:       #{exchange_register.hierarchical_name}",
      "  splits:         #{reminder_splits.size}",
      reminder_splits.map do |split|
        [
          "    - register: #{split.register.hierarchical_name}",
          "      amount:   #{split.amount}",
          "      memo:     #{split.memo}"
        ]
      end,
      ""
    ].flatten.map!(&:rstrip).join("\n")
  end
end
