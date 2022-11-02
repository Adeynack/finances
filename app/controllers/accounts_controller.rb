# frozen_string_literal: true

class AccountsController < ApplicationController
  def index
    @accounts = @book.accounts
  end
end
