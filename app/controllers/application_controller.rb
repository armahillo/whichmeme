class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :load_user_metadata

  rescue_from CanCan::AccessDenied do |e|
  	redirect_to new_user_session_path, alert: e.message
  end

  def about
  end

  def news
    @news = News.all.order('created_at DESC')
  end

  def index
    @users = User.ranked.limit(25)
    @recent_news = News.order('updated_at DESC').limit(3)
    @header_meme = Meme.new
    @header_meme.meme_type = MemeType.find_by_name("All The Things")
    @header_meme.meme_caption = ['TEST ALL THE MEMES','']
  end


  def stats
  	@meme_types = MemeType.order('instance_count DESC')
    @meme_count = Meme.count
  end

  def load_user_metadata
    # If the user isn't signed in, it's all moot!
  	return unless user_signed_in?

    # Since this is loaded on every page, we only want to calculate the values
    # if they are not already set. The values are updated by the individual controllers
    # that do the work.
    session[:user_metadata] ||= {}
    session[:user_metadata][:games] ||= {}
    session[:user_metadata][:games][:memetype_association] ||= current_user.memetype_associations_count
    session[:user_metadata][:games][:typememe_association] ||= current_user.typememe_associations_count
    session[:user_metadata][:games][:memetype_accuracy] ||= current_user.memetype_accuracy
    session[:user_metadata][:games][:typememe_accuracy] ||= current_user.typememe_accuracy
    session[:user_metadata][:games][:best_type] ||= current_user.best_type
  end
end
