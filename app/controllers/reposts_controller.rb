# app/controllers/reposts_controller.rb
class RepostsController < ApplicationController
  include ActionView::RecordIdentifier  # ✅ Makes `dom_id` usable in controller

  before_action :authenticate_user!
  before_action :set_post

  def create
    recent_repost = current_user.reposts
      .where(original_post_id: @post.id)
      .where("created_at > ?", 5.minutes.ago)
      .first

    if recent_repost
      flash[:alert] = "⏳ You’ve already reposted this recently. Try again in a few minutes."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@post, :repost),
            partial: "posts/repost_button",
            locals: { post: @post }
          )
        end
        format.html { redirect_to posts_path }
      end
      return
    end

    repost = current_user.posts.build(
      original_post: @post,
      caption: @post.caption,
      image: @post.image.blob,
      rating: @post.rating
    )

    if repost.save
    flash[:notice] = "🔁 Reposted!"
    current_user.reposted_posts.reset

    Turbo::StreamsChannel.broadcast_prepend_to(
        "posts",
        target: "posts",
        partial: "posts/post",
        locals: { post: repost }
    )

    else
    logger.error "Repost save failed: #{repost.errors.full_messages.join(', ')}" # ← Add this
    flash[:alert] = "Unable to repost."
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id(@post, :repost),
          partial: "posts/repost_button",
          locals: { post: @post }
        )
      end
      format.html { redirect_to posts_path }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
