# frozen_string_literal: true

class StringValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil?
      record.errors.add(attribute, :blank) unless options[:allow_nil] == true
      return
    end

    record.errors.add(attribute, :invalid) unless value.is_a?(String)
  end
end
