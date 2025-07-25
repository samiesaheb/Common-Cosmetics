class PostLikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = @post.likes.find_or_create_by(user: current_user)

    # ✅ Notify only if user is not liking their own post
    if @post.user != current_user && @like.persisted?
      unless Notification.exists?(actor: current_user, notifiable: @post, recipient: @post.user, action: "liked")
        Notification.create!(
          actor: current_user,
          recipient: @post.user,
          notifiable: @post,
          action: "liked"
        )
      end
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
