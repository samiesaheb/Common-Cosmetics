class UsersController < ApplicationController
  def show
    begin
      @user = User.friendly.find(params[:username])
      @posts = @user.posts
                .includes(user: { avatar_attachment: :blob }, image_attachment: :blob)
                .order(created_at: :desc)
      Rails.logger.debug "User found: #{@user.inspect}, Posts: #{@posts.count}"
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error "User not found for username: #{params[:username]}"
      respond_to do |format|
        format.html { redirect_to posts_path, alert: "User not found." }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("main_content", partial: "shared/error", locals: { message: "User not found." }) }
      end
    end
  end

  def autocomplete
    query = params[:query].to_s.downcase
    users = User.where("username ILIKE ?", "#{query}%").limit(5)
    render json: users.as_json(only: [:username], methods: [:avatar_url])
  end


end