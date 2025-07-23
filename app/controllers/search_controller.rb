class SearchController < ApplicationController
  def index
    query = params[:q].to_s.strip.downcase

    @users = User.where("username ILIKE ?", "%#{query}%")
    @posts = Post.where("caption ILIKE ?", "%#{query}%")

    respond_to do |format|
      format.html # renders search/index.html.erb
    end
  end
end
