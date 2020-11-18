class UsersController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']

    user = User.find_by(uid: auth_hash[:uid], provider: params[:provider])
    if user
      flash[:success] = "Logged in as returning user: #{user.username}."
    else
      user = User.build_from_github(auth_hash)

      if user.save
        flash[:success] = "Successfully created new user: #{user.username}."
      else
        flash[:error] = "Sorry, we were unable to create that user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = user.id
    redirect_to root_path
  end

  def logout
    # if session[:user_id]
      user = User.find_by(id: session[:user_id])
      user ? flash[:success] = 'Successfully logged out' : flash[:notice] = 'Error: unknown user'
      session[:user_id] = nil
    # else
    #   authentication_notice
    # end

    redirect_to root_path
  end

end