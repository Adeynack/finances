# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    @books = policy_scope(Book)
    @books = @books.where(owner: current_user) unless params.key?(:all)
  end

  def show
    @book = Book.find(params[:id])
  end
end
