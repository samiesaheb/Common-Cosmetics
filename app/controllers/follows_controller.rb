class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.friendly.find(params[:user_id])
    current_user.following << user unless current_user.following.include?(user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(user) }
    end
  end

  def destroy
    user = User.friendly.find(params[:user_id])
    current_user.following.destroy(user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(user) }
    end
  end
end
