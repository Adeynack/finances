# typed: strong
# frozen_string_literal: true

module Pundit
  sig do
    params(
      user: T.untyped,
      record: T.untyped,
      query: T.nilable(Symbol)
    ).returns(T::Boolean)
  end
  def authorize(user, record, query: nil); end

  sig do
    params(
      user: T.untyped,
      scope: T.untyped
    ).returns(T.untyped)
  end
  def policy_scope(user, scope); end

  sig do
    params(
      user: T.untyped,
      record: T.untyped
    ).returns(T.untyped)
  end
  def policy(user, record); end
end

class ApplicationPolicy
  sig { params(scope: T::Hash[Symbol, T.untyped], record: T.untyped).void }
  def initialize(scope, record); end

  class << self
    sig do
      params(
        association_names: T.any(Symbol, T::Array[Symbol]),
        allowed_actions: T::Array[Symbol],
        options: T::Hash[Symbol, T.untyped]
      ).void
    end
    def allow_association_actions(association_names, *allowed_actions, **options); end
  end
end

module Pundit
  class NotAuthorizedError < StandardError; end
end
