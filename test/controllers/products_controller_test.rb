require "test_helper"

describe ProductsController do

  let (:user) { User.first }
  let (:product) { Product.first }
  let (:product_hash) {
    {
        product: {
            name: 'new_name'
        }
    }
  }

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

  ##################################################

  # Guest user tests
  describe 'guest user' do
    describe 'edit' do
      it 'products#edit: will not allow a guest user to edit and will redirect' do
        get edit_product_path(product.id)
        expect(flash[:error]).must_equal 'Please log in to perform this action.'
        must_redirect_to root_path
      end
    end

    describe 'update' do
      it 'products#update: will not allow a guest user to update and will redirect' do
        expect { patch product_path(product.id), params: product_hash }.wont_change 'Product.count'
        expect(flash[:error]).must_equal 'Please log in to perform this action.'
        must_redirect_to root_path
      end
    end

    describe 'retire' do
      it 'products#retire: will not allow a guest user to retire a product and will redirect' do
        patch retire_product_path(product)
        expect(flash[:error]).must_equal 'Please log in to perform this action.'
        must_redirect_to root_path
      end
    end
  end

  ##################################################

  # Logged-in user tests
  describe 'logged-in merchant user' do
    before do
      perform_login(user)
    end

    describe 'edit' do

    end

    describe 'update' do

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
