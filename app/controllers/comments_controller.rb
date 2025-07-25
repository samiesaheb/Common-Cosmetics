class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      MentionParser.new(@comment).call

      # ✅ Notification for comment on post
      unless @comment.user == @post.user
        if @comment.parent_id.present?
          parent_comment = Comment.find_by(id: @comment.parent_id)

          if parent_comment && parent_comment.user != current_user
            Notification.create!(
              actor: current_user,
              recipient: parent_comment.user,
              action: "replied",
              notifiable: @comment
            )
          end
        elsif @post.user != current_user
          Notification.create!(
            actor: current_user,
            recipient: @post.user,
            action: "commented",
            notifiable: @comment
          )
        end
      end

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to post_path(@post), notice: "Comment added." }
      end
    else
      turbo_frame_id =
        if @comment.parent_id.present?
          dom_id(@comment, :form)
        else
          "new_comment_post_#{@post.id}"
        end

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
  