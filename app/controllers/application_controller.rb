class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def logged_in?
    User.find_by_id(session[:user_id])
  end

  helper_method :logged_in?
end
