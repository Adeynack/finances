# frozen_string_literal: true

module Types
  GraphqlAttributeMapper = Data.define(:model, :attributes) do
    # Maps the model's attributes from the Rails realm to
    # the GraphQL realm.
    def map_attributes_and_visit
      raise ArgumentError, "A block is needed to visit the mapped attributes" unless block_given?

      model_columns = model.columns.index_by(&:name)
      attributes.each do |attribute|
        column = model_columns[attribute.to_s] || raise(ArgumentError, "column `#{attribute}` does not exist on model `#{model.class}`.")
        yield(attribute:, graphql_type: to_gql_type(column), nullable: column.null)
      end
    end

    private

    def to_gql_type(column)
      case column.type.to_s
      when "boolean" then GraphQL::Types::Boolean
      when "date" then GraphQL::Types::ISO8601Date
      when "datetime" then GraphQL::Types::ISO8601DateTime
      when "decimal" then Float
      when "enum" then String
      when "integer" then Integer
      when "string" then String
      when "text" then String
      when "uuid" then GraphQL::Schema::Member::GraphQLTypeNames::ID
      else raise ArgumentError, "no mapping from column type `#{column.type}` to GraphQL types."
      end
    end
  end.freeze
end
