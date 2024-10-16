# frozen_string_literal: true

class BookPolicy < ApplicationPolicy
  allow_association_actions [:accounts, :categories], except: [:attach, :detach], if: :update?

  def index?
    current_user
  end

  def show?
    admin? || record.owner == current_user
  end

  def create?
    current_user
  end

  def create_book?
    create?
  end

  def update?
    admin? || record.owner == user
  end

  def destroy?
    admin? || record.owner == user
  end

  def destroy_book_fast?
    admin? && destroy?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless current_user # no user, no books
      return scope.all if current_user.admin? # admin sees all
      current_user.books # only the current user's owned books
    end
  end
end
