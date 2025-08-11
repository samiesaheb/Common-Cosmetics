class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_id])
    current_user.following << @user unless current_user == @user

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to username_profile_path(username: @user.username) }
    end
  end

  def destroy
    @user = User.find(params[:followed_id])
    current_user.following.destroy(@user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to username_profile_path(username: @user.username) }
    end
  end
end
