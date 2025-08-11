class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  validates :content, presence: true

  # ✅ Only comments with no parent (top-level)
  scope :top_level, -> { where(parent_id: nil) }

  after_create :notify_post_owner

  private
  def notify_post_owner
    return if post.user_id == user_id
    Notification.create!(
      recipient: post.user,
      actor: user,
      action: "commented_on_your_post",
      notifiable: self
    )
  end
end
