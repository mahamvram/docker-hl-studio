class ApplicationController < ActionController::Base
before_action :configure_permitted_parameters, if: :devise_controller?


protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :user_role, :user_designation, :hprofile_link])
  end

private
  def after_sign_in_path_for(resource_or_scope)
    if !resource_or_scope.nil?
      root_path
    end
  end
end
