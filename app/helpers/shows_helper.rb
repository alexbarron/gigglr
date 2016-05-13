module ShowsHelper
  def shows_index_options
    if admin_check?
      render 'shows_index_options'
    end
  end

  def shows_show_options(show)
    if admin_check?
      render partial: 'shows/shows_show_options', locals: { show: show }
    end
  end
end
