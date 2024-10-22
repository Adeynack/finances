# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    include ContextScopable

    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def authorized?(**args)
      # by default, require authentication for all mutations
      raise GraphQL::ExecutionError, "Not authorized" unless current_api_session.present?
      true
    end

    alias_method :original_authorize, :authorize
    def authorize(resource, permission = "#{field.name.underscore}?")
      original_authorize(resource, permission)
    end
  end
end
