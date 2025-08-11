class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"


  after_create :notify_followed

  private
  def notify_followed
    return if follower_id == followed_id
    Notification.create!(
      recipient: followed,
      actor: follower,
      action: "followed_you",
      notifiable: self
    )
  end
end
