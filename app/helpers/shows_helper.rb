module ShowsHelper
  def shows_index_options
    if admin_check?
      render 'shows_index_options'
    end
  end
end
