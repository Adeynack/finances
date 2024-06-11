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
  validates :exchange_register, inclusion: {in: ->(r) { r.book.registers }, message: :must_belong_to_reminder_book}
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
      "  register:    #{exchange_register.ancestry_path.to_a.join(" / ")}",
      reminder_splits.map do |split|
        [
          "    - register: #{split.register.ancestry_path.to_a.join(" / ")}",
          "      amount:   #{split.amount}",
          "      memo:     #{split.memo}"
        ]
      end,
      ""
    ].flatten
  end
end
