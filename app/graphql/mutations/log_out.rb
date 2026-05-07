# frozen_string_literal: true

module Mutations
  class LogOut < BaseMutation
    def authorized?(**args)
      true
    end

    def resolve
      ApiSession.log_out(
        rails_session: context[:session],
        current_api_session: context[:current_api_session]
      )

      {}
    end
  end
end
