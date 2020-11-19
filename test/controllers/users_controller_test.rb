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

end
