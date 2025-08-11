class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to post_path(@post), notice: "Comment added." }
      end
    else
      redirect_to post_path(@post), alert: "Comment could not be saved."
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to post_path(@comment.post), notice: "Comment deleted." }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id) # ✅ Added :parent_id
  end
end
