class CommentLikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment

  def create
    @comment_like = @comment.comment_likes.find_or_create_by(user: current_user)

    # ✅ Notification for comment like
    unless Notification.exists?(actor: current_user, notifiable: @comment_like, recipient: @comment.user)
      Notification.create!(
        actor: current_user,
        recipient: @comment.user,
        action: "liked your comment",
        notifiable: @comment_like
      )
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path }
    end
  end

  def destroy
    @comment_like = @comment.comment_likes.find_by(user: current_user)
    @comment_like&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end
end
