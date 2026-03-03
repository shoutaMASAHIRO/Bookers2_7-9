class BooksController < ApplicationController
  def index
    @book = Book.new
    @to = Time.current.at_end_of_day
    @from = 6.days.ago.at_beginning_of_day
    
    if params[:latest]
      @books = Book.all.order(created_at: :desc)
    elsif params[:star_count]
      @books = Book.all.order(star: :desc)
    else
      @books = Book.includes(:favorites).sort_by { |x| x.favorites.where(created_at: @from..@to).size }.reverse
    end
    
    @user = current_user
  end

  def show
    @Bookshow = Book.new
    @book = Book.find(params[:id])
    @book.increment!(:view_counts)
    @user = User.find(current_user.id)
    @book_comment = BookComment.new
  end

    # 投稿データの保存
    def create
      @book = Book.new(book_params)
      @book.user_id = current_user.id
      if @book.save
        flash[:success] = "Post was successfully"
        redirect_to book_path(@book.id)
      else
        @to = Time.current.at_end_of_day
        @from = 6.days.ago.at_beginning_of_day
        @books = Book.includes(:favorites).sort_by { |x| x.favorites.where(created_at: @from..@to).size }.reverse
        @user = User.find(current_user.id)
        render :index
      end
    end

    def edit
      @book = Book.find(params[:id])
      unless @book.user == current_user
       redirect_to books_path
      end
    end

    def update
      @book = Book.find(params[:id])
      # starは更新させない
      if @book.update(book_params.except(:star))
        flash[:success] = "Edit was successfully"
        redirect_to book_path(@book.id)
      else
        render :edit
      end
    end

    def destroy
      book = Book.find(params[:id])
      book.destroy
      flash[:success] = "Book was successfully Destroyed."
      redirect_to '/books'
    end

    # 投稿データのストロングパラメータ
  private

  def book_params
    params.require(:book).permit(:title, :body, :star, :category)
  end

end
