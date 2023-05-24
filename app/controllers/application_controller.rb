# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_user
  attr_reader :current_user

  private

  def set_user
    @current_user = User.first!
  end
end
