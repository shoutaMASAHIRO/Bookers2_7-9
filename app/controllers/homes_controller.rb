class HomesController < ApplicationController
  def top
    if user_signed_in?
      redirect_to user_path(current_user.id)
    end
  end

  def about
  end
end
