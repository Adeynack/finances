# frozen_string_literal: true

class CategoriesController < ApplicationController
  # @route GET /books/:book_id/categories (book_categories)
  def index
    @category_tree = @book.categories.hash_tree
  end
end
