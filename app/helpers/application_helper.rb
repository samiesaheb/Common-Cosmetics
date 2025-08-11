module ApplicationHelper
  # Robust relative time that works in HTML and Turbo Stream renders
  def relative_time(time)
    text = ActionController::Base.helpers.distance_of_time_in_words_to_now(time)
    "#{text} ago"
  end
  def unread_notifications_count
    return 0 unless current_user
    current_user.notifications.unread.count
  end
end
