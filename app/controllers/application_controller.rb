class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def after_sign_in_path_for(resource)
    '/dashboard'
  end
  
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
  
  private
  
  def ensure_admin
    unless current_user.admin?
      flash[:error] = 'You are not authorized to edit users.'
      redirect_to root_path
    end 
  end
  
end
