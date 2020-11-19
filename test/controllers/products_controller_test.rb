require "test_helper"

describe ProductsController do

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

end
