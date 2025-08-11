class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor,     class_name: "User"
  belongs_to :notifiable, polymorphic: true

  validates :action, presence: true
  scope :unread, -> { where(read_at: nil) }

  def read?
    read_at.present?
  end

  def mark_read!
    update!(read_at: Time.current)
  end

  # Nice, human-friendly message. Keep this simple; we can expand later.
  def message
    case action
    when "followed_you"
      "#{actor.username} followed you"
    when "liked_your_post"
      "#{actor.username} liked your post"
    when "commented_on_your_post"
      "#{actor.username} commented on your post"
    when "tagged_followed_product"
      product = metadata["product_name"] || "a product you follow"
      "#{actor.username} tagged #{product}"
    else
      "You have a new notification"
    end
  end

  # Where should the notification link to?
  def url
    case action
    when "followed_you"
      Rails.application.routes.url_helpers.username_profile_path(username: actor.username)
    when "liked_your_post", "commented_on_your_post"
      post = if notifiable.respond_to?(:post) && notifiable.post
               notifiable.post
             elsif notifiable.is_a?(Post)
               notifiable
             elsif notifiable.respond_to?(:likeable) && notifiable.likeable.is_a?(Post)
               notifiable.likeable
             else
               nil
             end
      post ? Rails.application.routes.url_helpers.post_path(post) : "#"
    when "tagged_followed_product"
      post_id = metadata["post_id"]
      post_id ? Rails.application.routes.url_helpers.post_path(post_id) : "#"
    else
      "#"
    end
  end
end
