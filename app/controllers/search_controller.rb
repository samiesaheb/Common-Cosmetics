class SearchController < ApplicationController
  def index
    query  = params[:q].to_s.strip.downcase
    rating = params[:rating]
    sort   = params[:sort] || "recent"
    type   = params[:type] # "users", "posts", or nil (both)

    @users = []
    @posts = []

    if type != "posts"
      @users = User.where("username ILIKE ?", "%#{query}%")
    end

    if type != "users"
      @posts = Post
        .includes(:user, :product_tags, image_attachment: :blob, user: { avatar_attachment: :blob })
        .references(:product_tags)
        .where(
          "posts.caption ILIKE :q OR product_tags.name ILIKE :q",
          q: "%#{query}%"
        )
        .distinct

      @posts = @posts.where(rating: rating) if rating.present?

      @posts = case sort
               when "top_rated"
                 @posts.order(rating: :desc)
               when "most_commented"
                @posts = Post
                  .left_joins(:comments)
                  .joins(:user)
                  .includes(:product_tags) # minimal includes — avoids ActiveStorage issues
                  .select("posts.*, COUNT(comments.id) AS comments_count")
                  .group("posts.id, users.id")
                  .order("comments_count DESC")
               else
                 @posts.order(created_at: :desc)
               end
    end
  end
end
