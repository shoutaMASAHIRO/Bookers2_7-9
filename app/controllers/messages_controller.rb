class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:message][:room_id])
    if @room.users.include?(current_user)
      @message = Message.new(message_params)
      @message.user_id = current_user.id
      if @message.save
        redirect_to room_path(@room)
      else
        @messages = @room.messages.order(created_at: :asc)
        @entries = @room.user_rooms.where.not(user_id: current_user.id)
        render 'rooms/show'
      end
    else
      redirect_to root_path, alert: "Action prohibited."
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :room_id)
  end
end
