class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])
  end

  private
  
  def set_current_user
    Current.user = current_user if user_signed_in?
  end
end


