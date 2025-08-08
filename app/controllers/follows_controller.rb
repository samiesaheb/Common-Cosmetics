class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:followed_id])
    current_user.following << user unless current_user == user
    redirect_to username_profile_path(username: user.username)
  end

  def destroy
    user = User.find(params[:followed_id])
    current_user.following.destroy(user)
    redirect_to username_profile_path(username: user.username)
  end
end
