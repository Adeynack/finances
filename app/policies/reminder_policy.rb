# frozen_string_literal: true

class ReminderPolicy < ApplicationPolicy
  def create_reminder?
    book_editor?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
