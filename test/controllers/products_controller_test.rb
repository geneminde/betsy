require 'test_helper'

describe ProductsController do

  let(:user) { User.first }
  let(:product) { Product.first }

  describe 'index' do
    it 'can get the index path' do
      # Act
      get products_path
      # Assert
      must_respond_with :success
    end

    it 'can get the root path' do
      # Act
      get root_path
      # Assert
      must_respond_with :success
    end
  end

  describe 'show' do
    it 'will redirect for an invalid path' do
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

  # Logged-in user tests
  describe 'logged-in merchant user' do
    before do
      perform_login(user)
    end

    describe 'edit' do
      it 'can get the products path' do
        get edit_product_path(product)

        must_respond_with :success
      end

      it 'shows an error for invalid product path' do
        get edit_product_path(-1)

        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    describe 'update' do
      it 'works for a valid update' do
        update = {product: {description: 'They got jokes'}}

        expect {
          put product_path(product), params: update
        }.wont_change 'Product.count'
        updated_product = Product.find_by(id: product.id)

        expect(updated_product.description).must_equal 'They got jokes'
        must_respond_with :redirect
        must_redirect_to current_user_path
      end

      it 'shows flash message for products not updated' do
        updates = {product: {name: nil}}

        expect {
          put product_path(product), params: updates
        }.wont_change 'Product.count'

        expect(flash[:error])
        assert(:error, "A problem occurred: Could not update #{product.name}")
      end

      it 'renders edit form for incomplete data' do
        updates = {product: {name: nil}}

        expect {
          put product_path(product), params: updates
        }.wont_change 'Product.count'

        expect(flash[:error])
        assert :edit
      end
    end

    describe 'new' do
      it 'works' do
        get new_product_path

        must_respond_with :success
      end
    end

    describe 'create' do
      it "creates a product with valid data" do

        new_product = {product: {name: "oxygen", price: '50', quantity: '10'}}

        expect {
          post products_path, params: new_product
        }.must_change "Product.count", 1

        new_product_id = Product.find_by(name: "oxygen").id

        must_respond_with :redirect
        must_redirect_to product_path(new_product_id)
      end
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

    describe 'find_product' do
      it 'has flash message for incorrect ID' do
        bogus_id = product.id
        product.destroy

        put product_path(bogus_id)

        expect(flash[:error])
        assert 'Uh oh! That product could not be found... Please try again.'

      end
      it 'redirects for incorrect ID' do
        bogus_id = product.id
        product.destroy

        put product_path(bogus_id)

        must_redirect_to products_path

      end
    end
  end

end
