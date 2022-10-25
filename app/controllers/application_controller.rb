# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Shimmer::Localizable
  include Shimmer::RemoteNavigation
  include Pundit::Authorization

  before_action :check_locale
  before_action :authenticate_user!
  before_action :set_book

  private

  def set_book
    b = params[:book_id]&.then { Book.find(_1) }
    b ||= current_user&.default_book
    @book = authorize(b) if b
  end
end
