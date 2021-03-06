class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :store_location

  private

	def admin_user
  		if !user_signed_in? || !current_user.admin?
  			redirect_to(root_url)
  		end
 	end

	def store_location
      return unless request.get? 
      if (request.path != "/users/sign_in" &&
          request.path != "/users/sign_up" &&
          request.path != "/users/password/new" &&
          request.path != "/users/password/edit" &&
          request.path != "/users/confirmation" &&
          request.path != "/users/sign_out" &&
          !request.xhr?) # don't store ajax calls
        session[:previous_url] = request.fullpath
      end
    end

    def after_sign_in_path_for(resource)
      segment_identify
      follow_after_authentication if params[:user][:com_id]
      session[:previous_url] || root_path
    end

    def after_sign_up_path_for(resource)
      segment_identify
      follow_after_authentication if params[:user][:com_id]
      session[:previous_url] || root_path
    end

    private

    def follow_after_authentication
      comedian = Comedian.find(params[:user][:com_id])
      current_user.follow(comedian) unless current_user.fan_of?(comedian)
    end

    def segment_identify
      Analytics.identify(
        user_id: current_user.id,
        traits: {
          email: current_user.email,
          created_at: DateTime.now
        })
    end
end
