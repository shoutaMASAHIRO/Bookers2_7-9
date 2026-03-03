class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    # DMを開始する
    user = User.find(params[:user_id])
    
    # 自身がフォローしているか確認
    unless current_user.following?(user)
      redirect_to user_path(user), alert: "You can only DM users you are following."
      return
    end

    # 既に2人の部屋があるか探す
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.where(user_id: user.id, room_id: rooms)

    if user_rooms.any?
      @room = user_rooms.first.room
    else
      @room = Room.create
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: user.id, room_id: @room.id)
    end
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    # 自分がこの部屋のメンバーか確認
    unless @room.users.include?(current_user)
      redirect_to root_path, alert: "Access denied."
      return
    end
    @messages = @room.messages.order(created_at: :asc)
    @message = Message.new
    @entries = @room.user_rooms.where.not(user_id: current_user.id)
  end
end
