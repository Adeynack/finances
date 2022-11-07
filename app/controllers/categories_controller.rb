# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @category_tree = @book.categories.hash_tree
  end
end
