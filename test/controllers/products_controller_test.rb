require "test_helper"

describe ProductsController do

  let(:user) { User.first }
  let(:product) { Product.first }

  describe "index" do
    it "can get the index path" do
      # Act
      get products_path
      # Assert
      must_respond_with :success
    end

    it "can get the root path" do
      # Act
      get root_path
      # Assert
      must_respond_with :success
    end
  end

  describe 'show' do
    it "will redirect for an invalid path" do
      # Act
      get product_path(-1)
      # Assert
      must_respond_with :redirect
    end

    it 'can get a valid product' do
      product = products(:product1)
      get product_path(product)
      must_respond_with :success
    end
  end

  describe 'edit' do
    it 'can get the products path' do
      get edit_product_path(product)

      must_respond_with :found
    end

    it 'shows an error for invalid product path' do
      get edit_product_path(-1)

      must_respond_with :redirect
    end
  end

  describe 'new' do
    it 'works' do


      get new_product_path

      must_respond_with :success
    end
  end

  ##################################################

  # Logged-in user tests
  describe 'logged-in merchant user' do
    before do
      perform_login(user)
    end

    describe 'retire' do
      it 'will flash an error message and redirect to current_user_path if product is nil' do
        patch retire_product_path(-1)
        must_respond_with :redirect
        must_redirect_to products_path
      end

      it 'will redirect if product is successfully changed retirement status' do
        patch retire_product_path(product)
        must_respond_with :redirect
        must_redirect_to current_user_path
      end
    end
  end

end
