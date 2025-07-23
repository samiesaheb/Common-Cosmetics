# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    scope = current_user.notifications.grouped

    case params[:filter]
    when "mentioned"
      @notifications = scope.select { |n| n.action == "mentioned" }
    when "liked"
      @notifications = scope.select { |n| n.action == "liked" }
    else
      @notifications = scope
    end
  end


  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read!

    # 🚀 Update the unread count badge via Turbo Stream
    Turbo::StreamsChannel.broadcast_replace_to(
      "notifications_user_#{current_user.id}",
      target: "notification-count",
      partial: "notifications/count",
      locals: { count: current_user.notifications.unread.count }
    )

    # Redirect to content
    destination =
      case @notification.notifiable
      when Post
        post_path(@notification.notifiable)
      when Comment
        post_path(@notification.notifiable.post, anchor: "comment-#{@notification.notifiable.id}")
      else
        nil
      end

    if destination.present?
      redirect_to destination
    else
      redirect_to notifications_path, alert: "That content is no longer available."
    end
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to notifications_path, notice: "All notifications marked as read." }
    end
  end
end
