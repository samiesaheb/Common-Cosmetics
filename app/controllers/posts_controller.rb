class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts
  def index
    if user_signed_in?
      followed_ids = current_user.following.pluck(:id)
      @posts = Post.where(user_id: followed_ids + [current_user.id])
                  .includes(:user, image_attachment: :blob)
                  .order(created_at: :desc)
    else
      @posts = Post.none
    end
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!
    redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed."
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:content, :image, :rating)
    end
end
