# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Shimmer::Localizable
  include Shimmer::RemoteNavigation
  include Pundit::Authorization

  before_action :check_locale
  before_action :authenticate_user!
end
