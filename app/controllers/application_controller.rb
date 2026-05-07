# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  attr_reader :current_api_session
  before_action :set_current_api_session

  private

  def set_current_api_session
    @current_api_session = nil
    session_used = false

    token = request.headers["Authorization"].presence
    if token
      # ensure it is a bearer token
      return fail_from_invalid_token(session_used:) unless token.start_with?("Bearer ")
      token = token.delete_prefix("Bearer ")
    else
      # fallback to the session cookie, if no Authorization header is present
      token = session[:api_session_token].presence
      return unless token # no token, no session: carry on unauthenticated.

      session_used = true
    end

    @current_api_session = ApiSession.find_by(token:)
    fail_from_invalid_token(session_used:) unless @current_api_session
  end

  def fail_from_invalid_token(session_used:)
    session.delete(:api_session_token) if session_used
    render json: {status: 401, errors: [{message: "Invalid bearer token"}]}, status: :unauthorized
  end
end
