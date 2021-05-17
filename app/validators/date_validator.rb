# frozen_string_literal: true

# Validates that the value is either a Date, or a string representing one.
# Blank strings are threated as nil.
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.is_a?(Date)

    if value.blank?
      record.errors.add(attribute, :blank) unless options[:allow_nil] == true
      return
    end

    return record.errors.add(attribute, :invalid) unless value.is_a?(String)

    value_as_date = as_date(value)
    record.errors.add(attribute, :invalid) if value_as_date.nil?
  end

  private

  def as_date(value)
    Date.parse(value)
  rescue Date::Error
    nil
  end
end
