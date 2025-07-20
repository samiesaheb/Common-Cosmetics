# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :recipient, polymorphic: true
  belongs_to :notifiable, polymorphic: true
  belongs_to :actor, class_name: "User", optional: true

  scope :unread, -> { where(read_at: nil) }

  def mark_as_read!
    update(read_at: Time.current)
  end

  def message
    "#{actor.username} #{action} in your #{notifiable_type.downcase}."
  end
end
