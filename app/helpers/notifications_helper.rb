# app/helpers/notifications_helper.rb
module NotificationsHelper
  def notification_message(notification)
    actor = notification.actor&.username || "Someone"
    case notification.action
    when "liked_post"
      "#{actor} liked your post."
    when "liked_comment"
      "#{actor} liked your comment."
    when "commented"
      "#{actor} commented on your post."
    when "replied"
      "#{actor} replied to your comment."
    when "liked_reply"
      "#{actor} liked your reply."
    when "followed"
      "#{actor} followed you."
    else
      "#{actor} did something."
    end
  end
end
