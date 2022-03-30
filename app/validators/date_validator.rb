# frozen_string_literal: true

# Validates that the value is either a Date, or a string representing one.
# Blank strings are threated as nil.
# Nil is allowed by default.
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add(attribute, :blank) unless options.fetch(:allow_nil, true)
      return
    end

    return record.errors.add(attribute, :invalid) unless value.is_a?(String) || value.is_a?(Date)

    value = as_date(value)
    record.errors.add(attribute, :invalid) if value.nil?

    options[:after]&.tap do |after_option|
      after_value, after_part = determine_comparison_value(record, after_option)
      record.errors.add(attribute, :date_not_after, attribute:, value:, after_part:) unless value.after?(after_value)
    end

    # TODO: SHIMMER: Add option for `before`.
  end

  private

  def as_date(value)
    value.to_date
  rescue Date::Error
    nil
  end

  def determine_comparison_value(record, comparison_option)
    if comparison_option.is_a?(Symbol)
      value = record.send(comparison_option)
      comparison_part = "#{comparison_option} (#{value})"
    else
      value = comparison_option
      comparison_part = value
    end
    [value, comparison_part]
  end
end
