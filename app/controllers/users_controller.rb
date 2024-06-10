# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # @route GET /users/:id (user)
  def show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
