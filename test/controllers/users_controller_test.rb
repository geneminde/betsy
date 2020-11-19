require 'test_helper'

describe UsersController do

  let (:user) { User.first }

  # Guest user tests
  describe 'guest user' do
    it 'users#show: can browse products by merchant' do
      get user_path(user.id)
      must_respond_with :success
    end

    it 'users#current_user: cannot access merchant dash' do
      get current_user_path
      expect(flash[:error]).must_equal 'Please log in to perform this action.'
      must_redirect_to root_path
    end

    it 'users#login: creates an account for a new user and redirects to the root route' do
      new_user = User.new(
        username: 'username',
        provider: 'github',
        email: 'someone@somewhere.com',
        uid: 123
      )

      expect{
        perform_login(new_user)
      }.must_change 'User.count', 1

      must_redirect_to root_path
      expect(session[:user_id]).must_equal User.last.id
    end

    it 'users#login: can log in an existing user and redirects to the root route' do
      start_count = User.count
      perform_login(user)

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      expect(User.count).must_equal start_count
    end

    it 'users#login: redirects to the login route if given invalid user data' do
      new_user = User.new(
        username: nil,
        provider: 'github',
        email: 'someone@somewhere.com',
        uid: 123
      )

      expect{
        perform_login(new_user)
      }.wont_change 'User.count'

      must_redirect_to root_path
      assert_nil(session[:user_id])

      user = User.find_by(uid: new_user.uid, provider: new_user.provider)
      expect(user).must_equal nil
    end

    it 'users#logout: cannot logout if not already logged in' do
      delete logout_path

      expect(flash[:error]).must_equal 'Please log in to perform this action.'
      must_redirect_to root_path
    end
  end

  ##################################################

  # Logged-in user tests
  describe 'logged-in merchant user' do
    before do
      perform_login(user)
    end

    it 'users#current_user: can return user/merchant page if a user is logged in' do
      get current_user_path
      must_respond_with :success
    end

    it 'users#logout: can logout a logged-in user' do
      delete logout_path

      assert_nil(session[:user_id])
      must_redirect_to root_path
    end
  end

  ##################################################

  # General functionality outside of auth
  describe 'show' do
    it 'responds with success when showing an existing valid user' do
      get user_path(User.first.id)
      must_respond_with :success
    end

    it 'will redirect when passed an invalid user id' do
      get user_path(-1)
      must_respond_with :redirect
    end
  end
end
