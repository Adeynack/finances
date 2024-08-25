# frozen_string_literal: true

module AuthHelper
  attr_reader :current_api_session

  def login!(user:)
    @current_api_session = ApiSession.new(user:, token: "TEST TOKEN")
  end

  def logout!
    @current_api_session = nil
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
  config.include AuthHelper, type: :graphql
end
