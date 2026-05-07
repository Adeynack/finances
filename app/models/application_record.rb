# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :scope_if, ->(condition, scope, *args, **options) { public_send(scope, *args, **options) if condition }
  scope :scope_unless, ->(condition, scope, *args, **options) { public_send(scope, *args, **options) unless condition }

  class << self
    def execute_sql(query:, variables: {})
      statement = sanitize_sql_array [query, variables]
      connection.execute(statement)
    end

    def closure_trees
      @@closure_trees ||= []
    end

    def has_closure_tree(*args, **kwargs, &block)
      super
      closure_trees << self
    end

    def rebuild_all!
      closure_trees.each(&:rebuild!)
    end
  end

  def execute_sql(query:, variables: {})
    self.class.execute_sql query:, variables:
  end
end
