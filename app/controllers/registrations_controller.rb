class RegistrationsController < Devise::RegistrationsController

private
 
  def sign_up_params
    params.require(:user).permit(:email, :location, :password, :distance_pref, :password_confirmation)
  end
 
  def account_update_params
    params.require(:user).permit(:email, :location, :distance_pref, :password, :password_confirmation, :current_password)
  end
end
