# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :set_current_api_session

  def home
  end
end
