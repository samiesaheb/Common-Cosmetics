class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts
  def index
    if user_signed_in?
      followed_ids = current_user.following.pluck(:id)
      @posts = Post
        .where(user_id: followed_ids + [current_user.id])
        .includes(:user, :products, image_attachment: :blob)
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
    @post = current_user.posts.new(post_params.except(:product_names))
    pn = post_params[:product_names]
    @post.product_names = pn if pn.present?          # <-- guard
    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post.assign_attributes(post_params.except(:product_names))
    pn = post_params[:product_names]
    @post.product_names = pn if pn.present?          # <-- guard (keep existing if field missing)
    if @post.save
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
      @post = Post.includes(:user, :products, image_attachment: :blob).find(params[:id])
    end

    def post_params
      params.require(:post).permit(:content, :image, :rating, :product_names)
    end
end
