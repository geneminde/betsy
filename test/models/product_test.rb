require "test_helper"

describe Product do
  let (:product) { Product.first }

  describe 'relationships' do

  end

  describe 'validations' do

  end

  describe 'custom methods' do
    it 'can toggle retirement status' do
      original_status = product.is_retired
      product.toggle_retire

      if original_status == false
        expect(product.is_retired).must_equal true
      else
        expect(product.is_retired).must_equal false
      end
    end

    it 'will change available status to true if changing from retired to active and quantity > 0' do
      product.is_retired = true
      product.quantity = 10

      product.toggle_retire

      expect(product.is_retired).must_equal false
      expect(product.available).must_equal true
    end

    it 'will change available status to false if changing from retired to active and quantity == 0' do
      product.is_retired = true
      product.quantity = 0

      product.toggle_retire

      expect(product.is_retired).must_equal false
      expect(product.available).must_equal true
    end
  end
end
