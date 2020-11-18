class ApplicationController < ActionController::Base

  before_action :require_login

  def current_user
    return @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    if current_user.nil?
      flash[:error] = 'Please log in to complete that action.'
      redirect_to root_path
    end
  end

end