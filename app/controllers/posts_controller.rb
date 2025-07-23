class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @posts = Post
      .includes(user: { avatar_attachment: :blob }, image_attachment: :blob)
      .order(created_at: :desc)
      .page(params[:page])
      .per(10)
  end

  def show
    @post = Post.find(params[:id])

    if user_signed_in? && params[:notification_id].present?
      notification = current_user.notifications.find_by(id: params[:notification_id])
      notification&.mark_as_read!
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      MentionParser.new(@post).call

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, notice: "Post created successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_post_form", partial: "posts/form", locals: { post: @post }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  def edit; end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post deleted successfully."
  end

  def more
    @posts = Post
      .includes(user: { avatar_attachment: :blob }, image_attachment: :blob)
      .order(created_at: :desc)
      .page(params[:page])
      .per(10)

    render turbo_stream: turbo_stream.append(
      "posts_list",
      partial: "posts/post",
      collection: @posts,
      as: :post
    )
  end

  def more_comments
    @post = Post.find(params[:id])
    @comments = @post.comments.where(parent_id: nil).order(created_at: :asc)

    render turbo_stream: turbo_stream.replace(
      "comments_post_#{@post.id}",
      partial: "comments/preview_wrapper",
      locals: { post: @post }
    )
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    redirect_to posts_path, alert: "You are not authorized to do that." unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:caption, :rating, :image)
  end
end