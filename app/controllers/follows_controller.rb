class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.friendly.find(params[:user_username])
    current_user.following << @user unless current_user.following.include?(@user)

    # ✅ Notification for follow
    unless Notification.exists?(actor: current_user, recipient: @user, action: "followed you")
      Notification.create!(
        actor: current_user,
        recipient: @user,
        action: "followed you",
        notifiable: current_user
      )
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(@user) }
    end
  end

  def destroy
    @user = User.friendly.find(params[:user_username])
    current_user.following.destroy(@user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(@user) }
    end
  end
end
