class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :load_user_metadata

  rescue_from CanCan::AccessDenied do |e|
  	redirect_to new_user_session_path, alert: e.message
  end

  def index
  	@meme_types = MemeType.order('instance_count DESC')
  end

  def load_user_metadata
  	return unless user_signed_in?
    @user_metadata = {}
    @user_metadata["games"] = {}
    @user_metadata["games"]["memetype_association"] = Games::MemetypeAssociation.by_user(current_user.id).count
  end
end
