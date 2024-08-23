# frozen_string_literal: true

class RegisterPolicy < ApplicationPolicy
  def create_category?
    book_editor?
  end

  def create_account?
    book_editor?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        user.books
      end
    end
  end
end
