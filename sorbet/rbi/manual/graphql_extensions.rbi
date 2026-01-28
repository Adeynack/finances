# typed: strong
# frozen_string_literal: true

module GraphQL
  class Schema
    class Object
      sig do
        params(
          name: T.any(String, Symbol),
          type: T.untyped,
          null: T::Boolean,
          description: T.nilable(String),
          method: T.nilable(Symbol),
          hash_key: T.nilable(T.any(String, Symbol)),
          resolver: T.nilable(Class),
          resolver_method: T.nilable(Symbol),
          deprecation_reason: T.nilable(String)
        ).void
      end
      def self.field(
        name,
        type = nil,
        null: true,
        description: nil,
        method: nil,
        hash_key: nil,
        resolver: nil,
        resolver_method: nil,
        deprecation_reason: nil,
        &block
      ); end
    end

    class Mutation < GraphQL::Schema::Object
      sig do
        params(
          name: T.any(String, Symbol),
          type: T.untyped,
          required: T::Boolean,
          description: T.nilable(String),
          default_value: T.untyped,
          as: T.nilable(Symbol)
        ).void
      end
      def self.argument(
        name,
        type,
        required: true,
        description: nil,
        default_value: nil,
        as: nil
      ); end

      sig do
        params(
          name: T.any(String, Symbol),
          type: T.untyped,
          null: T::Boolean,
          description: T.nilable(String)
        ).void
      end
      def self.field(
        name,
        type = nil,
        null: true,
        description: nil
      ); end
    end

    class RelayClassicMutation < GraphQL::Schema::Mutation
    end

    class Enum < GraphQL::Schema::Member
      sig { params(name: String, value: T.untyped, description: T.nilable(String)).void }
      def self.value(name, value: name, description: nil); end
    end

    class InputObject < GraphQL::Schema::InputObject
      sig do
        params(
          name: T.any(String, Symbol),
          type: T.untyped,
          required: T::Boolean,
          description: T.nilable(String),
          default_value: T.untyped
        ).void
      end
      def self.argument(
        name,
        type,
        required: true,
        description: nil,
        default_value: nil
      ); end
    end
  end

  class ExecutionError < StandardError; end
end

module Types
  class BaseObject < GraphQL::Schema::Object
    sig { returns(T.nilable(ApiSession)) }
    def current_api_session; end

    sig { returns(T.nilable(User)) }
    def current_user; end
  end

  module BaseMutation < GraphQL::Schema::RelayClassicMutation
    sig { returns(T.nilable(ApiSession)) }
    def current_api_session; end

    sig { returns(T.nilable(User)) }
    def current_user; end

    sig do
      params(
        resource: T.untyped,
        permission: String
      ).returns(T.untyped)
    end
    def authorize(resource, permission = "#{field.name.underscore}?"); end
  end
end
