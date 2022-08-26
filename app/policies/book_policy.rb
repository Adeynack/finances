# frozen_string_literal: true

class BookPolicy < ApplicationPolicy
  def index?
    true
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
