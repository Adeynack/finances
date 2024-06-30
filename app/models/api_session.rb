# frozen_string_literal: true

# == Schema Information
#
# Table name: api_sessions
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null, indexed
#  token      :string           not null, indexed
#
class ApiSession < ApplicationRecord
  belongs_to :user

  before_validation :ensure_token

  class CreateNewSessionError < StandardError; end

  class << self
    def log_in(email:, password:, rails_session:, current_api_session:)
      user = User.find_by(email:) || raise(CreateNewSessionError, "user not found")
      raise(CreateNewSessionError, "incorrect password") unless user.authenticate(password)

      # If the request is already authenticated by bearer token, `current_api_session` is already set.
      # Otherwise, if the token of the current session is still valid, use the same session (do not create a new one for nothing).
      current_api_session ||= rails_session[:api_session_token].presence&.then { |token| user.api_sessions.find_by(token:) }
      # Otherwise, create a new session.
      current_api_session ||= user.api_sessions.create!

      # Set the `user_id` to the session to allow users of GraphiQL to log in (cookie-based).
      rails_session[:api_session_token] = current_api_session.token

      current_api_session
    rescue
      # Anything goes wrong: destroy session (cookie & token).
      rails_session[:api_session_token] = nil
      current_api_session&.destroy!
      raise
    end

    def log_out(rails_session:, current_api_session:)
      rails_session[:api_session_token] = nil
      current_api_session&.destroy!
    end
  end

  private

  def ensure_token
    self.token = SecureRandom.base64(64) if token.blank?
  end
end
