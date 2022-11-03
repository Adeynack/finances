# frozen_string_literal: true

class AccountsController < ApplicationController
  def index
    @show_inactive = params[:show_inactive] == "1"
    @accounts = @book.accounts.scope_unless(@show_inactive, :active)
  end
end
