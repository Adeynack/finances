# frozen_string_literal: true

module ContextScopable
  extend ActiveSupport::Concern

  included do
    def current_user
      current_api_session&.user
    end

    def current_api_session
      context[:current_api_session]
    end

    def session
      context[:session]
    end

    def pundit_scope
      {session:, current_api_session:}
    end

    def authorize(resource, permission = "#{field.name.underscore}?")
      Pundit.authorize(pundit_scope, resource, permission)
    end

    def policy_scope(scope)
      Pundit.policy_scope!(pundit_scope, scope)
    end
  end
end
