# frozen_string_literal: true

class IBANValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil?
      record.errors.add(attribute, :blank) unless options[:allow_nil] == true
      return
    end

    return if IBANTools::IBAN.valid?(value)

    record.errors.add(attribute, :invalid)
  end
end
