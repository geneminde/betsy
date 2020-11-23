class UsersController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def not_found_error_notice
    flash[:error] = 'Uh oh! That user could not be found... Please try again.'
    redirect_to users_path
  end

  ##################################################

  def index
    @users = User.all
  end

  def show
    user_id = params[:id].to_i
    @user = User.find_by(id: user_id)
    if @user.nil?
      not_found_error_notice
      return
    end
  end

  def current_user
    if session[:user_id]
      return @current_user = User.find_by(id: session[:user_id])
    else
      flash[:error] = 'Please log in to perform this action.'
      redirect_to root_path
    end
  end

  def create
    if session[:user_id]
      flash[:error] = 'Error: already logged in.'
      return redirect_to root_path
    end

    # # BELOW IS FOR TESTING PURPOSES ONLY - TO DELETE BEFORE FINAL SUBMISSION
    # session[:user_id] = User.find(19).id
    # redirect_to root_path

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

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Successfully logged out.'
    redirect_to root_path
  end

end