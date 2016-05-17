module ComediansHelper

  def comedians_index_options
    if admin_check?
      render 'comedians/admin_comedian_options'
    end
  end

  def comedian_show_options(comedian)
    if admin_check?
      render partial: 'comedians/comedian_show_options', locals: { comedian: comedian }
    end
  end

  def follow_unfollow(comedian)
    if !!current_user && comedian.users.include?(current_user)
      render partial: 'unfollow', locals: { comedian: comedian }
    elsif !!current_user
      render partial: 'follow', locals: { comedian: comedian }
    else
      button_to 'Follow', new_user_session_path, method: :get, class: 'btn btn-primary', params: { :com_id => comedian.id }
    end
  end
end
