class LikesController < ApplicationController
  before_action :authenticate_user!

    def create
    @likeable = find_likeable
    current_user.likes.create!(likeable: @likeable)

    respond_to do |format|
        format.html { redirect_back fallback_location: root_path }
        format.turbo_stream
    end
    end

    def destroy
    @likeable = find_likeable
    like = current_user.likes.find_by!(likeable: @likeable)
    like.destroy

    respond_to do |format|
        format.html { redirect_back fallback_location: root_path }
        format.turbo_stream
    end
    end

  private

  def find_likeable
    likeable_type = params[:likeable_type]
    likeable_id = params[:likeable_id]
    likeable_type.constantize.find(likeable_id)
  end
end
