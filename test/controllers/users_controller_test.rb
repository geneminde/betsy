require "test_helper"

describe UsersController do

  describe 'show' do
    it "responds with success when showing an existing valid user" do
      get user_path(User.first.id)
      must_respond_with :success
    end

    it "will redirect when passed an invalid user id" do
      get user_path(-1)
      must_respond_with :redirect
    end
  end

  describe 'current user' do
    # it 'can return user page if a user is logged in' do
    #   login
    #   get current_user_path
    #   must_respond_with :success
    # end

    it 'redirects if user is not logged in' do
      get current_user_path
      must_respond_with :redirect
      expect(flash[:error]).must_equal 'Please log in to perform this action.'
    end
  end
end
