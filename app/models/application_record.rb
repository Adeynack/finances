# typed: true
# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  extend T::Sig

  primary_abstract_class

  scope :scope_if, ->(condition, scope, *args, **options) { public_send(scope, *args, **options) if condition }
  scope :scope_unless, ->(condition, scope, *args, **options) { public_send(scope, *args, **options) unless condition }

  class << self
    extend T::Sig

    sig { params(query: String, variables: T::Hash[Symbol, T.untyped]).returns(T.untyped) }
    def execute_sql(query:, variables: {})
      statement = sanitize_sql_array [query, variables]
      connection.execute(statement)
    end

    sig { returns(T::Array[T.class_of(ApplicationRecord)]) }
    def closure_trees
      @@closure_trees ||= []
    end

    sig { params(args: T.untyped, kwargs: T.untyped, block: T.nilable(T.proc.void)).void }
    def has_closure_tree(*args, **kwargs, &block)
      super
      closure_trees << self
    end

    sig { void }
    def rebuild_all!
      closure_trees.each(&:rebuild!)
    end
  end

  sig { params(query: String, variables: T::Hash[Symbol, T.untyped]).returns(T.untyped) }
  def execute_sql(query:, variables: {})
    self.class.execute_sql query:, variables:
  end
end
