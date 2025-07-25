class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    current_user.bookmarked_posts << post unless current_user.bookmarked_posts.include?(post)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("bookmark_post_#{post.id}", partial: "posts/bookmark", locals: { post: post }) }
      format.html { redirect_to post_path(post), notice: "Bookmarked." }
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    current_user.bookmarked_posts.delete(post)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("bookmark_post_#{post.id}", partial: "posts/bookmark", locals: { post: post }) }
      format.html { redirect_to post_path(post), notice: "Removed bookmark." }
    end
  end
end
