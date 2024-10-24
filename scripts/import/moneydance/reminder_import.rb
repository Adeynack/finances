# frozen_string_literal: true

require_relative "utils"
require "montrose"

module MoneydanceImport
  class ReminderImport
    include MoneydanceImport::Utils

    def initialize(create_progress_bar:, api_client:, book:, md_items_by_type:, register_id_by_md_acctid:)
      @api_client = api_client
      @create_progress_bar = create_progress_bar
      @book = book
      @md_items_by_type = md_items_by_type
      @register_id_by_md_acctid = register_id_by_md_acctid
    end

    def import_reminders
      puts "Importing reminders"
      reminders = @md_items_by_type["reminder"].to_a

      bar = @create_progress_bar.call title: "Creating reminders", total: reminders.size
      @api_client.bar = bar

      reminders.each do |md_reminder|
        bar.log "Importing reminder '#{md_reminder["desc"]}' (#{md_reminder["id"]})"
        import_reminder(bar:, md_reminder:)
      end
    ensure
      @api_client.bar = nil
    end

    private

    def import_reminder(bar:, md_reminder:)
      transaction, splits = extract_transaction_hash_from_reminder(md_reminder:)
      reminder = {
        import_origin: {system: "moneydance", id: md_reminder["id"]},
        # created_at: from_md_unix_date(md_reminder["txn.dtentered"], DateTime.current),
        book_id: @book.id,
        title: md_reminder["desc"].presence,
        mode: "manual",
        first_date: from_md_int_date(md_reminder["sdt"].presence),
        last_date: from_md_int_date(md_reminder["ldt"].presence),
        recurrence: extract_reminder_recurence(md_reminder).as_json,
        last_commit_at: from_md_unix_date(md_reminder["ts"]), # TODO: Is `ts` not "last updated at" like on registers?
        exchange_register_id: @register_id_by_md_acctid[transaction.fetch("acctid")],
        exchange_description: transaction["desc"].presence,
        exchange_memo: transaction["memo"].presence,
        exchange_status: from_md_stat(transaction["stat"]),
        splits: splits.map { import_reminder_split(_1) }
      }
      @api_client.create_reminder(reminder:)
      bar.increment
    end

    def extract_transaction_hash_from_reminder(md_reminder:)
      transaction_hash = {}
      splits_per_index = {}

      md_reminder.each_key do |key|
        key_parts = key.split(".")
        next unless key_parts.length > 1 && key_parts.first == "txn"

        if key_parts.length == 2
          transaction_hash[key_parts[1].to_s] = md_reminder.delete(key).to_s
        else
          index = key_parts[1].to_i
          split = splits_per_index[index] ||= {}
          attribute = key_parts.drop(2).to_a.join(".")
          split[attribute] = md_reminder.delete(key).to_s
        end
      end
      ordered_splits = splits_per_index.keys.sort.map { |i| splits_per_index.fetch(i) }

      [transaction_hash, ordered_splits]
    end

    def extract_reminder_recurence(md_reminder)
      schedules = [
        extract_reminder_recurence_daily(md_reminder),
        extract_reminder_recurence_weekly(md_reminder),
        extract_reminder_recurence_monthly(md_reminder),
        extract_reminder_recurence_yearly(md_reminder)
      ]
      schedules.compact!
      raise StandardError, "multiple schedules are not supported by this import" if schedules.length > 1

      schedules.first
    end

    def extract_reminder_recurence_daily(md_reminder)
      daily_interval = md_reminder["daily"]&.to_i
      return nil unless daily_interval&.positive?

      Montrose.every((daily_interval == 1) ? :day : daily_interval.days)
    end

    WEEKDAY_MAPPING = [nil, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].freeze

    def extract_reminder_recurence_weekly(md_reminder)
      weekly_days = md_reminder.fetch("weeklydays", "").split(",")
      weekly_days.map! { |i| WEEKDAY_MAPPING[i.to_i] }
      weekly_days.compact!
      return nil if weekly_days.empty?

      week_step = md_reminder.fetch("weeklymod", 0).to_i + 1

      Montrose.every((week_step == 1) ? :week : week_step.weeks, on: weekly_days)
    end

    def extract_reminder_recurence_monthly(md_reminder)
      monthly_days = md_reminder.fetch("monthlydays", "").split(",")
      monthly_days.map!(&:to_i).map! do |day|
        case day
        when 0 then nil
        when 32 then -1 # Day 32 in Moneydance means "last day of the month" (-1 in Montrose)
        else day
        end
      end
      monthly_days.compact!
      return nil if monthly_days.empty?

      month_step = md_reminder.fetch("monthlymod", 0).to_i + 1

      Montrose.every((month_step == 1) ? :month : month_step.months, mday: monthly_days)
    end

    def extract_reminder_recurence_yearly(md_reminder)
      yearly_interval = md_reminder["yearly"]&.to_i
      return nil unless yearly_interval&.positive?

      Montrose.every((yearly_interval == 1) ? :year : yearly_interval.years)
    end

    def import_reminder_split(md_split)
      {
        register_id: @register_id_by_md_acctid[md_split.fetch("acctid")],
        amount: md_split["samt"].to_i,
        counterpart_amount: md_split["pamt"].to_i,
        memo: md_split["desc"].presence,
        status: from_md_stat(md_split["stat"]),
        tags: md_split.fetch("tags", "").split("\t"),
        import_origin: {system: "moneydance", id: md_split["id"]}
      }
    end
  end
end
