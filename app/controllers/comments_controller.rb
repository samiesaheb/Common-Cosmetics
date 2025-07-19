class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to post_path(@post), notice: "Comment added." }
      end
    else
      turbo_frame_id = @comment.parent_id.present? ? dom_id(@comment.parent, :reply_form) : "new_comment_post_#{@post.id}"

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            turbo_frame_id,
            partial: "comments/form",
            locals: { post: @post, comment: @comment }
          )
        end

        format.html { redirect_to post_path(@post), alert: "Comment could not be saved." }
      end
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: "Comment deleted." }
      end
    else
      head :unauthorized
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
