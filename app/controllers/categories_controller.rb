# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = @book.categories
  end
end
