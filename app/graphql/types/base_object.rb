# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    class << self
      def auto_fields(model, *attributes)
        GraphqlAttributeMapper.new(model:, attributes:).map_attributes_and_visit do |attribute:, graphql_type:, nullable:|
          raise ArgumentError, "field `#{attribute}` is being redefined" if fields.key?(attribute.to_s)

          field attribute, graphql_type, null: nullable
        end
      end
    end
  end
end
