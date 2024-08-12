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
    user
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
