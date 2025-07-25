class UsersController < ApplicationController
  def show
    begin
      @user = User.friendly.find(params[:username])

      if params[:tab] == "bookmarks"
        if current_user == @user
          @posts = @user.bookmarked_posts
                        .includes(user: { avatar_attachment: :blob }, image_attachment: :blob)
                        .order(created_at: :desc)
          Rails.logger.debug "User found: #{@user.inspect}, Bookmarked Posts: #{@posts.count}"
        else
          redirect_to user_path(@user), alert: "Bookmarks are private." and return
        end
      else
        @posts = @user.posts
                      .includes(user: { avatar_attachment: :blob }, image_attachment: :blob)
                      .order(created_at: :desc)
        Rails.logger.debug "User found: #{@user.inspect}, Posts: #{@posts.count}"
      end

    rescue ActiveRecord::RecordNotFound
      Rails.logger.error "User not found for username: #{params[:username]}"
      respond_to do |format|
        format.html { redirect_to posts_path, alert: "User not found." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("main_content", partial: "shared/error", locals: { message: "User not found." })
        end
      end
    end
  end

  def autocomplete
    query = params[:query].to_s.downcase
    users = User.where("username ILIKE ?", "#{query}%").limit(5)
    render json: users.as_json(only: [:username], methods: [:avatar_url])
  end
end
