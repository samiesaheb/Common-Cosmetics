class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:username])
    @posts = @user.posts
                 .includes(user: { avatar_attachment: :blob }, image_attachment: :blob)
                 .order(created_at: :desc)
  end

  def autocomplete
    query = params[:query].to_s.downcase
    users = User.where("username ILIKE ?", "#{query}%").limit(5)
    render json: users.select(:username)
  end

end
