class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
                                 .order(created_at: :desc)
                                 .limit(100) # tune or paginate later
  end

  def update
    notification = current_user.notifications.find(params[:id])
    notification.mark_read!
    redirect_to notification.url
  end

  def mark_all_read
    current_user.notifications.unread.update_all(read_at: Time.current, updated_at: Time.current)
    redirect_to notifications_path, notice: "All caught up!"
  end
end
