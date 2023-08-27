# frozen_string_literal: true
# typed: true

class AccountsController < ApplicationController
  # @route GET /books/:book_id/accounts (book_accounts)
  def index
    @show_inactive = params[:show_inactive] == "1"
    @account_tree = @book.accounts.scope_unless(@show_inactive, :active).hash_tree
  end
end
