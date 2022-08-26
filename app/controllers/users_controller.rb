# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
  end

  private

  def set_user
    binding.pry unless User.where(id: params[:id]).exists?
    @user = User.find(params[:id])
  end
end
