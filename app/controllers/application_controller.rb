class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:warning] = 'You are not authorized'
    redirect_to(request.referrer || '/')
  end

  def logged_in?
    User.find_by_id(session[:user_id])
  end

  def current_user
    logged_in?
  end

  helper_method :logged_in?
  helper_method :current_user
end
