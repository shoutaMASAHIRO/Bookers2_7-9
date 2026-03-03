class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @groups = Group.all
    @book = Book.new
    @user = current_user
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
    @user = current_user
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      @group.users << current_user
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end

  def new_event_notice
    @group = Group.find(params[:group_id])
  end

  def send_event_notice
    @group = Group.find(params[:group_id])
    @title = params[:title]
    @body = params[:body]
    @group.users.each do |member|
      EventMailer.send_event_email(member, @title, @body).deliver_now
    end
    render :sent_event_notice
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
