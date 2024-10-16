# frozen_string_literal: true

class ExchangePolicy < ApplicationPolicy
  def create_exchange?
    book_editor?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
