module ApplicationHelper

  def admin_check?
    !!current_user && current_user.admin?
  end
  
end
