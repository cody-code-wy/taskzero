class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def logged_in?
    User.find_by_id(session[:user_id])
  end

  def current_user
    logged_in?
  end

  helper_method :logged_in?
  helper_method :current_user
end
