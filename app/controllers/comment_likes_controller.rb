class CommentLikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment

  def create
    @comment_like = @comment.comment_likes.find_or_create_by(user: current_user)

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
