class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  # ✅ Helper method to check if the message was sent by the given user
  def sent_by?(current_user)
    user_id == current_user.id
  end
end
