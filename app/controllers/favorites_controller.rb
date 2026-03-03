class FavoritesController < ApplicationController
  before_action :set_book
  before_action :set_time_range

  def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save
    respond_to do |format|
      format.js  # create.js.erb で処理を返す
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy if favorite
    respond_to do |format|
      format.js  # destroy.js.erb で処理を返す
    end
  end
  

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_time_range
    @to = Time.current.at_end_of_day
    @from = 6.days.ago.at_beginning_of_day
  end
end
