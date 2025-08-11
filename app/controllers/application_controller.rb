class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :normalize_flash_keys
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Map alternate flash keys to a single pair so they don't render twice
  def normalize_flash_keys
    if flash[:success].present?
      flash[:notice] ||= flash[:success]
      flash.delete(:success)
    end

    if flash[:warning].present? && flash[:alert].blank?
      flash[:alert] = flash.delete(:warning)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:username, :avatar, :bio, :first_name, :last_name]
    )
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:username, :avatar, :bio, :first_name, :last_name]
    )
  end
end
