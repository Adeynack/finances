# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :scope_if, ->(condition, scope, *args, **options) { public_send(scope, *args, **options) if condition }
  scope :scope_unless, ->(condition, scope, *args, **options) { public_send(scope, *args, **options) unless condition }
end
