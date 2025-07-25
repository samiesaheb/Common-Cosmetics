# app/models/like.rb
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id } # prevent double likes

  after_create_commit :notify_recipient

  private

  def notify_recipient
    return if post.user == user || post.user.nil? # ✅ no self-notify, guard nil

    Notification.create!(
      recipient: post.user,
      notifiable: post,
      actor: user,             # ✅ this ensures correct grammar
      action: "liked"
    )
  end
end
