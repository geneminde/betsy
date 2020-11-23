require "test_helper"

describe CategoriesController do
  describe 'index' do
    it 'gets the index page' do
      get categories_path
      must_respond_with :success
    end
  end
end
