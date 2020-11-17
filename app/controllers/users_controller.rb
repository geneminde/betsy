class UsersController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']

    user = User.find_by(uid: auth_hash[:uid], provider: params[:provider])
    if user
      flash[:success] = "Logged in as returning user #{user.username}."
    else
      # TODO: Attempt to create a new user
    end

    session[:user_id] = user.id
    redirect_to root_path
  end

end