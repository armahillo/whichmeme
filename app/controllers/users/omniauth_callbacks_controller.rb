class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
  	@user = User.from_omniauth(request.env["omniauth.auth"])

  	if @user.persisted?
  		sign_in_and_redirect @user #, event: :authentication # Warden callback
  		set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?		
  	else
  		session["devise.facebook_data"] = request.env["omniauth.auth"]
  		redirect_to new_user_registration_url
  	end
  end

  def google_oauth2
    Rails.logger.info "Loading User record from OAuth"
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    end
    redirect_to profile_path
  end

  def failure
	super
  end
end
