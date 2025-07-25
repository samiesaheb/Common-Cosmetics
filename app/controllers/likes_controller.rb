class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    like = @post.likes.find_or_create_by(user: current_user)

    Rails.logger.debug "🏷️ post.user.id: #{@post.user.id}, current_user.id: #{current_user.id}"
    Rails.logger.debug "🏷️ like.persisted?: #{like.persisted?}"

    # ✅ Only notify if liking someone else's post
    if like.persisted? && @post.user.present? && @post.user != current_user
      Notification.create!(
        recipient: @post.user,     # ✅ not `user:`
        actor: current_user,
        notifiable: @post,
        action: "liked"
      )
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "like_post_#{@post.id}",
          partial: "likes/like_button",
          locals: { post: @post }
        )
      end
      format.html { redirect_back fallback_location: posts_path }
    end
  end

  def destroy
    current_user.likes.find_by(post: @post)&.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "like_post_#{@post.id}",
          partial: "likes/like_button",
          locals: { post: @post }
        )
      end
      format.html { redirect_back fallback_location: posts_path }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
