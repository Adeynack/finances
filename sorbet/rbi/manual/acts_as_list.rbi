# typed: strong
# frozen_string_literal: true

module ActiveRecord
  class Base
    sig do
      params(
        scope: T.nilable(T.any(Symbol, Proc)),
        column: T.nilable(Symbol),
        top_of_list: T.nilable(Integer)
      ).void
    end
    def self.acts_as_list(scope: nil, column: nil, top_of_list: nil); end
  end
end

module ActsAsList
  sig { returns(T.nilable(Integer)) }
  def position; end

  sig { params(value: T.nilable(Integer)).returns(Integer) }
  def position=(value); end

  sig { void }
  def move_higher; end

  sig { void }
  def move_lower; end

  sig { void }
  def move_to_top; end

  sig { void }
  def move_to_bottom; end

  sig { params(new_position: Integer).void }
  def insert_at(new_position); end

  sig { returns(T::Boolean) }
  def first?; end

  sig { returns(T::Boolean) }
  def last?; end

  sig { returns(T.nilable(T.untyped)) }
  def higher_item; end

  sig { returns(T.nilable(T.untyped)) }
  def lower_item; end
end
