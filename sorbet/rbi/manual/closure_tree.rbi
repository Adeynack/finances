# typed: strong
# frozen_string_literal: true

module ClosureTree
  module Model
    sig { returns(T.nilable(T.untyped)) }
    def parent; end

    sig { params(value: T.nilable(T.untyped)).returns(T.untyped) }
    def parent=(value); end

    sig { returns(ActiveRecord::Relation) }
    def children; end

    sig { returns(ActiveRecord::Relation) }
    def ancestors; end

    sig { returns(ActiveRecord::Relation) }
    def self_and_ancestors; end

    sig { returns(ActiveRecord::Relation) }
    def descendants; end

    sig { returns(ActiveRecord::Relation) }
    def self_and_descendants; end

    sig { returns(T::Hash[T.untyped, T.untyped]) }
    def hash_tree; end

    sig { returns(T::Boolean) }
    def root?; end

    sig { returns(T::Boolean) }
    def leaf?; end

    sig { returns(Integer) }
    def depth; end
  end
end

module ActiveRecord
  class Base
    sig do
      params(
        order: T.nilable(T.any(String, Symbol)),
        dependent: T.nilable(Symbol),
        numeric_order: T.nilable(T::Boolean),
        touch: T.nilable(T::Boolean)
      ).void
    end
    def self.has_closure_tree(
      order: nil,
      dependent: nil,
      numeric_order: nil,
      touch: nil
    ); end

    sig { void }
    def self.rebuild!; end
  end
end
