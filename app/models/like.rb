class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
  after_create :notify_post_owner

  private

  def notify_post_owner
    return unless likeable.is_a?(Post)
    return if likeable.user_id == user_id

    return if Notification.exists?(
      recipient_id: likeable.user_id,
      actor_id: user_id,
      action: "liked_your_post",
      notifiable: self
    )

    Notification.create!(
      recipient: likeable.user,
      actor: user,
      action: "liked_your_post",
      notifiable: self
    )
  end

end
