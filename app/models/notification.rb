class Notification < ApplicationRecord
  belongs_to :recipient, polymorphic: true
  belongs_to :notifiable, polymorphic: true
  belongs_to :actor, class_name: "User", optional: true

  scope :unread, -> { where(read_at: nil) }

  after_create_commit :broadcast_notification

  def mark_as_read!
    update(read_at: Time.current)
  end

  def message
    return "Someone interacted with your content." unless actor && notifiable

    content_type = case notifiable
                   when Post
                     "post"
                   when Comment
                     notifiable.parent_id.present? ? "reply" : "comment"
                   else
                     notifiable_type.downcase
                   end

    case action
    when "liked"
      "❤️ #{actor.username} liked your #{content_type}."
    when "commented"
      "💬 #{actor.username} commented on your post."
    when "replied"
      "↩️ #{actor.username} replied to your comment."
    when "mentioned"
      "📢 #{actor.username} mentioned you in a #{content_type}."
    when "followed"
      "➕ #{actor.username} followed you."
    else
      "#{actor.username} #{action} your #{content_type}."
    end
  end

  def self.grouped(limit: 10)
    select("MIN(id) AS id, action, notifiable_type, notifiable_id, COUNT(*) AS count, MAX(created_at) AS created_at")
      .group(:action, :notifiable_type, :notifiable_id)
      .order("created_at DESC")
      .limit(limit)
      .map do |group|
        newest = Notification.where(
          action: group.action,
          notifiable_type: group.notifiable_type,
          notifiable_id: group.notifiable_id
        ).order(created_at: :desc).first
        newest.define_singleton_method(:group_count) { group.count }
        newest
      end
  end

  private

  def broadcast_notification
    return unless recipient.is_a?(User)

    grouped_notifications = recipient.notifications.grouped
    unread_count = recipient.notifications.unread.count

    # ✅ Update notifications dropdown list
    broadcast_replace_to(
      "notifications_user_#{recipient.id}",
      target: "notifications",
      partial: "notifications/list",
      locals: { notifications: grouped_notifications }
    )

    # ✅ Update bell icon count with proper `count:`
    broadcast_replace_to(
      "notifications_user_#{recipient.id}",
      target: "notification-count",
      partial: "notifications/count",
      locals: { count: unread_count }
    )
  end
end
