class PostLikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = @post.likes.find_or_create_by(user: current_user)

    # ✅ Notification for post like
    unless Notification.exists?(actor: current_user, notifiable: @like, recipient: @post.user)
      Notification.create!(
        actor: current_user,
        recipient: @post.user,
        action: "liked your post",
        notifiable: @like
      )
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path }
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    @like&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
