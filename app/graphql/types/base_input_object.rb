# frozen_string_literal: true

module Types
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Types::BaseArgument

    class << self
      def auto_arguments(model, *attributes)
        GraphqlAttributeMapper.new(model:, attributes:).map_attributes_and_visit do |attribute:, graphql_type:, nullable:|
          raise ArgumentError, "argument `#{attribute}` is being redefined" if arguments.key?(attribute.to_s)

          argument attribute, graphql_type, required: !nullable
        end
      end
    end
  end
end
