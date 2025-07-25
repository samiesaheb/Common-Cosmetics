class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  has_many :messages, dependent: :destroy

  # Ensure uniqueness of sender-receiver pair (in one direction)
  validates :sender_id, uniqueness: { scope: :receiver_id }

  # Finds a conversation between two users regardless of who initiated it
  scope :between, ->(sender_id, receiver_id) {
    where(
      "(sender_id = :sender AND receiver_id = :receiver) OR (sender_id = :receiver AND receiver_id = :sender)",
      sender: sender_id, receiver: receiver_id
    )
  }

  def unread_by?(user)
    messages.where.not(user_id: user.id).where(read: false).exists?
  end

  def typing_user
    typing ? (last_typing_user || sender) : nil
  end

  # ✅ Step 6: Broadcast typing updates
  after_update_commit :broadcast_typing_status, if: :saved_change_to_typing?

  private

  def broadcast_typing_status
    Turbo::StreamsChannel.broadcast_replace_to(
      self,
      target: "typing_status",
      partial: "conversations/typing",
      locals: { conversation: self }
    )
  end

  belongs_to :last_typing_user, class_name: "User", optional: true

end
