# frozen_string_literal: true
# typed: true

class BookPolicy < ApplicationPolicy
  extend T::Sig

  allow_association_actions [:accounts, :categories], except: [:attach, :detach], if: :update?

  def index?
    user
  end

  def show?
    admin? || record.owner == user
  end

  def create?
    admin?
  end

  def update?
    admin? || record.owner == user
  end

  def destroy?
    admin? || record.owner == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user
        user.books
      else
        scope.none
      end
    end
  end
end
