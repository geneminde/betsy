require "test_helper"

describe CategoriesController do
  describe 'index' do
    it 'gets the index page' do
      get categories_path
      must_respond_with :success
    end
  end

  describe 'show' do
    it 'gets the show page' do
      category = categories(:category1)

      get category_path(category.id)

      must_respond_with :success
    end

    it 'gets the show page if there are no products in a category' do
      category = categories(:category2)

      get category_path(category.id)

      must_respond_with :success
    end

    it 'redirects to root_path for an invalid category' do
      category_id = -1

      get category_path(category_id)

      must_redirect_to root_path
    end
  end

  describe 'new' do
    it 'can get the form to create a new category if logged-in' do
      perform_login

      get new_category_path

      must_respond_with :success
    end

    it 'redirects to root_path if a user is not logged in' do
      get new_category_path

      must_respond_with :redirect
    end
  end

  describe 'create' do
    it 'can create a category' do
      perform_login
      category_hash = {
          category: {
              name: 'New Category'
          }
      }

      expect {
        post categories_path, params: category_hash
      }.must_differ 'Category.count', 1

      category = Category.find_by(name: "New Category")

      expect(category.name).must_equal "New Category"
    end

    it 'will not create a category with invalid params' do
      perform_login
      category_hash = {
          category: { name: nil}
      }

      expect {
        post categories_path, params: category_hash
      }.wont_change 'Category.count'

      must_respond_with :bad_request
    end
  end
end
