# frozen_string_literal: true

module Currencyable
  extend ActiveSupport::Concern

  KNOWN_CURRENCY_ISO_CODES = Money::Currency.all.map(&:iso_code).freeze

  class_methods do
    def ensure_the_currency_is_known(model_attribute)
      validates model_attribute,
        inclusion: {
          in: KNOWN_CURRENCY_ISO_CODES,
          allow_nil: true,
          message: "%{value} is not a known currency ISO code"
        }
    end

    def define_iso_code_setter(model_attribute)
      define_method :"#{model_attribute}=" do |new_value|
        super(new_value.upcase)
      end
    end

    def define_money_object_getter(attribute_name, model_attribute, money_instance_variable)
      define_method attribute_name do
        iso_code = public_send model_attribute
        currency = instance_variable_get(money_instance_variable)
        unless currency&.iso_code == iso_code
          currency = Money::Currency.new(iso_code)
          instance_variable_set(money_instance_variable, currency)
        end
        currency
      end
    end

    def define_money_object_setter(attribute_name, optional, model_attribute, money_instance_variable)
      define_method :"#{attribute_name}=" do |new_value|
        raise ArgumentError, "#{attribute_name} cannot be nil" if optional && new_value.nil?
        raise ArgumentError, "#{attribute_name} expected to be of type #{Money::Currency.name}" unless new_value.nil? || new_value.is_a?(Money::Currency)

        instance_variable_set(money_instance_variable, new_value)
        public_send :"#{model_attribute}=", new_value.iso_code
      end
    end

    def has_currency(attribute_name, optional: true)
      raise ArgumentError, "has_currency needs the symbol of the attribute representing the ISO code of a currency" unless attribute_name.is_a?(Symbol)

      model_attribute = :"#{attribute_name}_iso_code"
      money_instance_variable = :"@#{attribute_name}"

      ensure_the_currency_is_known(model_attribute)
      define_iso_code_setter(model_attribute)
      define_money_object_getter(attribute_name, model_attribute, money_instance_variable)
      define_money_object_setter(attribute_name, optional, model_attribute, money_instance_variable)
    end
  end
end
