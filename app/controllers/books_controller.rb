# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    @show_all = params.key?(:all)
    @books = policy_scope(Book)
    @books = @books.where(owner: current_user) unless @show_all
  end

  def show
  end

  private

  def set_book
    @book = params[:id]&.then { Book.find(_1) }&.then { authorize(_1) } || super
  end
end
