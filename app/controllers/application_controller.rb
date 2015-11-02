class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def admin_user
  	if !user_signed_in? || !current_user.admin?
  		redirect_to(root_url)
  	end
  end
end
