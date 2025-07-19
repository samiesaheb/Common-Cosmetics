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
        respond_to do |format|
        turbo_frame_id = @comment.parent_id.present? ? dom_id(@comment.parent, :reply_form) : "new_comment_post_#{@post.id}"

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

    # def edit
    # @comment = @post.comments.find(params[:id])
    # authorize_user!

    # respond_to do |format|
    #     format.turbo_stream {
    #     render partial: "comments/edit_form", locals: { post: @post, comment: @comment }
    #     }
    #     format.html { head :not_found } # Optional fallback
    # end
    # end


    # def update
    # @comment = @post.comments.find(params[:id])
    # authorize_user!

    # if @comment.update(comment_params)
    #     respond_to do |format|
    #     format.turbo_stream
    #     format.html { redirect_to posts_path, notice: "Comment updated." }
    #     end
    # else
    #     respond_to do |format|
    #     format.turbo_stream {
    #         render turbo_stream: turbo_stream.replace(
    #         dom_id(@comment, :edit),
    #         partial: "comments/edit_form",
    #         locals: { post: @post, comment: @comment }
    #         )
    #     }
    #     end
    # end
    # end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

    # def authorize_user!
    # head :unauthorized unless @comment.user == current_user
    # end
end
