# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read!

    if @notification.notifiable.is_a?(Like)
      post = @notification.notifiable.post
    else
      post = nil
    end

    if post.present?
      redirect_to post_path(post)
    else
      redirect_to notifications_path, alert: "That post is no longer available."
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
