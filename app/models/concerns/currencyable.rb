# frozen_string_literal: true

module Currencyable
  extend ActiveSupport::Concern

  KNOWN_CURRENCY_ISO_CODES = Money::Currency.all.map(&:iso_code).freeze

  class_methods do
    def has_currency(attribute_name, optional: false)
      raise ArgumentError, "has_currency needs the symbol of the attribute representing the ISO code of a currency" unless attribute_name.is_a?(Symbol)

      model_attribute = :"#{attribute_name}_iso_code"
      money_instance_variable = :"@#{attribute_name}"

      # Ensure the currency is known
      validates model_attribute,
        inclusion: {
          in: KNOWN_CURRENCY_ISO_CODES,
          allow_nil: optional,
          message: :invalid_currency_code
        }

      # ISO Code Setter
      define_method :"#{model_attribute}=" do |new_value|
        super(new_value.upcase)
      end

      # Money Object Getter
      define_method attribute_name do
        iso_code = public_send model_attribute
        currency = instance_variable_get(money_instance_variable)
        unless currency&.iso_code == iso_code
          currency = Money::Currency.new(iso_code)
          instance_variable_set(money_instance_variable, currency)
        end
        currency
      end

      # Money Object Setter
      define_method :"#{attribute_name}=" do |new_value|
        raise ArgumentError, "#{attribute_name} cannot be nil" if optional && new_value.nil?
        raise ArgumentError, "#{attribute_name} expected to be of type #{Money::Currency.name}" unless new_value.nil? || new_value.is_a?(Money::Currency)

        instance_variable_set(money_instance_variable, new_value)
        public_send :"#{model_attribute}=", new_value.iso_code
      end
    end
  end
end
