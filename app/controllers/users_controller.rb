class UsersController < ApplicationController
  def show
    if params[:username]
      @user = User.find_by!(username: params[:username])
    else
      @user = User.find(params[:id])
    end

    if user_signed_in?
      @is_following = current_user.following.exists?(@user.id)
    end
  end
end
