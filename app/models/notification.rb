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

    case action
    when "liked"
      if notifiable.is_a?(Post)
        "❤️ #{actor.username} liked your post."
      elsif notifiable.is_a?(Comment)
        type = notifiable.parent_id.present? ? "reply" : "comment"
        "❤️ #{actor.username} liked your #{type}."
      else
        type = notifiable_type&.downcase.presence || "content"
        "❤️ #{actor.username} liked your #{type}."
      end

    when "commented"
      if notifiable.is_a?(Comment)
        if notifiable.parent_id.present?
          "💬 #{actor.username} replied to your comment."
        else
          "💬 #{actor.username} commented on your post."
        end
      else
        "💬 #{actor.username} commented on your post."
      end

    when "replied"
      "↩️ #{actor.username} replied to your comment."

    when "mentioned"
      context = notifiable.is_a?(Post) ? "post" : "comment"
      "📢 #{actor.username} mentioned you in a #{context}."

    when "followed"
      "➕ #{actor.username} followed you."

    else
      type = notifiable_type&.downcase.presence || "content"
      "🔔 #{actor.username} #{action} your #{type}."
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
