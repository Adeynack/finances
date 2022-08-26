# frozen_string_literal: true

class BookPolicy < ApplicationPolicy
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

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif current_user
        user.books
      else
        scope.none
      end
    end
  end
end
