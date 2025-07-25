class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @tab = params[:tab] || "discover"

    @post = Post.new # ✅ Initialize for form_with in index view

    @posts =
      if @tab == "following"
        Post.where(user_id: current_user.following_ids)
      else
        Post.all
      end

    @posts = @posts
      .includes(:original_post, :product_tags, user: { avatar_attachment: :blob }, image_attachment: :blob)
      .order(created_at: :desc)
      .page(params[:page])
      .per(10)

    @suggested_users = User.suggested_for(current_user) if @tab == "discover"
  end

  def show
    @post = Post.find(params[:id])

    if user_signed_in? && params[:notification_id].present?
      notification = current_user.notifications.find_by(id: params[:notification_id])
      notification&.mark_as_read!
    end
  end

  def new
    @post = current_user.posts.build

    if params[:repost_id].present?
      original = Post.find_by(id: params[:repost_id])
      if original
        @post.original_post = original
        # 🛑 Do NOT prefill the caption — this should only be set by user manually for quote reposts
      else
        redirect_to posts_path, alert: "Original post not found" and return
      end
    end
  end

  def create
    @post = current_user.posts.build(post_params)

    # ✅ If original_post_id not present in strong params but we have a repost_id param, set it
    if @post.original_post_id.blank? && params[:repost_id].present?
      if original = Post.find_by(id: params[:repost_id])
        @post.original_post = original
      end
    end

    # ✅ If it's a repost and caption was left blank, treat it as a plain repost
    if @post.original_post.present? && params.dig(:post, :caption).blank?
      @post.caption = nil
    end

    if @post.save
      MentionParser.new(@post).call

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, notice: "Post created successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_post_form",
            partial: "posts/form",
            locals: { post: @post }
          )
        end
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
    params.require(:post).permit(
      :caption,
      :rating,
      :image,
      :product_tag_names,
      :original_post_id
    )
  end


end
