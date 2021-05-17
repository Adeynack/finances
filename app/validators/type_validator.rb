# frozen_string_literal: true

# Validates that the value if of one of the specified types.
class TypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil?
      record.errors.add(attribute, :cannot_be_empty) unless options[:allow_nil] == true
      return
    end

    type_options = Array.wrap(options[:with] || options[:in])
    return if allowed_types(type_options).include?(value.class)

    record.errors.add(attribute, error_message(type_options))
  end

  private

  def allowed_types(type_options)
    type_options.flat_map do |type|
      next type if type.is_a?(Class)

      SYMBOL_TYPES[type] || raise(ArgumentError, "type #{type} is not recognized by the type validator")
    end
  end

  def error_message(type_options)
    types_part = type_options.map { |type| SYMBOL_MESSAGE_PART[type] || type.name }.join(" or ")
    "must be #{types_part}"
  end

  SYMBOL_TYPES = {
    array: Array,
    big_decimal: BigDecimal,
    boolean: [TrueClass, FalseClass],
    date: Date,
    datetime: DateTime,
    float: Float,
    hash: Hash,
    integer: Integer,
    number: [Integer, Float, BigDecimal],
    string: String,
    symbol: Symbol,
    time: Time
  }.freeze

  SYMBOL_MESSAGE_PART = {
    array: "an array",
    big_decimal: "a BigDecimal",
    boolean: "a boolean",
    date: "a date",
    datetime: "a date & time",
    float: "a float",
    hash: "a hash",
    integer: "an integer",
    number: "a number",
    string: "a string",
    symbol: "a symbol",
    time: "a time"
  }.freeze
end
