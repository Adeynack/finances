# frozen_string_literal: true

class PagesController < ApplicationController
  # @route GET / (root)
  def home
    redirect_to(@book || books_path)
  end
end
