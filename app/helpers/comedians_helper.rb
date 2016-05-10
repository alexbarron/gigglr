module ComediansHelper

  def admin_options
    if admin_check?
      render 'comedians/admin_comedian_options'
    end
  end

  def follow_unfollow(comedian)
    if !!current_user && current_user.fan_of?(comedian)
      render partial: 'unfollow', locals: { comedian: comedian }
    elsif !!current_user
      render partial: 'follow', locals: { comedian: comedian }
    else
      button_to 'Follow', new_user_session_path, method: :get, class: 'btn btn-primary', params: { :com_id => comedian.id }
    end
  end
end
