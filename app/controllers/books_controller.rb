# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    @books = policy_scope(Book)
    @books = @books.where(owner: current_user) unless params.key?(:all)
  end

  def show
  end

  private

  def set_book
    @book = params[:id]&.then { Book.find(_1) }&.then { authorize(_1) } || super
  end
end
