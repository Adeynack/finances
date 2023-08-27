# frozen_string_literal: true

module Import::Moneydance
  class ReminderImport
    include Import::Moneydance::Utils

    def initialize(logger:, book:, md_items_by_type:, register_id_by_md_acctid:)
      @logger = logger
      @book = book
      @md_items_by_type = md_items_by_type
      @register_id_by_md_acctid = register_id_by_md_acctid
    end

    def import_reminders
      @logger.info "Importing reminders"
      @md_items_by_type["reminder"].to_a.each do |md_reminder|
        @logger.info "Importing reminder '#{md_reminder["desc"]}' (#{md_reminder["id"]})"
        import_reminder(md_reminder)
      end
    end

    private

    def import_reminder(md_reminder)
      transaction, splits = extract_transaction_hash_from_reminder(md_reminder)
      reminder = @book.reminders.create!(
        created_at: from_md_unix_date(md_reminder["txn.dtentered"], DateTime.current),
        title: md_reminder["desc"].presence,
        first_date: from_md_int_date(md_reminder["sdt"].presence),
        last_date: from_md_int_date(md_reminder["ldt"].presence),
        recurrence: extract_reminder_recurence(md_reminder),
        last_commit_at: from_md_unix_date(md_reminder["ts"]),
        exchange_register_id: @register_id_by_md_acctid[transaction.fetch("acctid")],
        exchange_description: transaction["desc"].presence,
        exchange_memo: transaction["memo"].presence,
        exchange_status: from_md_stat(transaction["stat"])
      )
      reminder.import_origins.create! external_system: "moneydance", external_id: md_reminder["id"]
      splits.each { |e| import_reminder_split(e, reminder) }
    end

    def extract_transaction_hash_from_reminder(md_reminder)
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
          attribute = key_parts[2..].to_a.join(".")
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

    def import_reminder_split(md_split, reminder)
      split = reminder.reminder_splits.create!(
        created_at: reminder.created_at,
        register_id: @register_id_by_md_acctid[md_split.fetch("acctid")],
        amount: md_split["samt"].to_i,
        counterpart_amount: md_split["pamt"].to_i,
        memo: md_split["desc"].presence,
        status: from_md_stat(md_split["stat"])
      )
      md_split.fetch("tags", "").split("\t").each { |tag| split.tag(tag) }
      split.import_origins.create! external_system: "moneydance", external_id: md_split["id"]
    rescue
      @logger.error "Error importing reminder split #{md_split["id"]}"
      raise
    end
  end
end
