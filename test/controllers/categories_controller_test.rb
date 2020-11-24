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

  describe 'edit' do
    it 'gets the edit page for when a user is logged-in' do
      perform_login

      category = categories(:category1)
      id = category.id

      get edit_category_path(id)

      must_respond_with :success
    end

    it 'redirects to categories_path if a user is not logged-in' do
      category = categories(:category1)
      id = category.id

      get edit_category_path(id)

      must_respond_with :redirect
    end

    it 'will respond with redirect for an invalid id' do
      perform_login

      id = -1

      get edit_category_path(id)
      must_respond_with :redirect
    end
  end

  describe 'update' do
    let(:category_hash) {
      {
          category: { name: "New Name" }
      }
    }

    it 'updates an existing category if a user is logged in' do
      perform_login
      category = categories(:category1)
      id = category.id

      expect {
        patch category_path(id), params: category_hash
      }.wont_change "Category.count"

      edited_category = Category.find_by(id: id)

      expect(edited_category.name).must_equal category_hash[:category][:name]
    end

    it 'does not update if the params are invalid' do
      perform_login
      category = categories(:category1)
      id = category.id

      invalid_category_hash = {
          category: {
              name: nil
          }
      }

      expect {
        patch category_path(id), params: invalid_category_hash
      }.wont_change "Category.count"

      category.reload
      must_respond_with :bad_request
      expect(category.name).wont_be_nil
    end

    it 'responds with redirect for invalid ids' do
      id = -1

      expect {
        patch category_path(id), params: category_hash
      }.wont_change 'Category.count'

      must_respond_with :redirect
    end
  end
end
