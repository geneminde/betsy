require "test_helper"

describe Product do
  let (:product) { Product.first }

  let (:review1) {
    Review.create!(rating: 5, product_id: product.id)
  }

  let (:review2) {
    Review.create!(rating: 3, product_id: product.id)
  }

  describe 'relationships' do
    it 'has many reviews' do
      review1
      review2

      expect(product.reviews.count).must_equal 2

      product.reviews.each do |review|
        expect(review).must_be_instance_of Review
      end
    end
  end

  describe 'validations' do
    it 'must have a name' do
      product.name = nil
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :name
    end

    it 'must have a unique name on create' do
      product = Product.new(name: Product.last.name,
                            description: 'some description',
                            price: 10,
                            quantity: 10
                            )

      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :name
      expect(product.errors.messages[:name]).must_equal ['has already been taken']
    end

    it 'does not need a unique name on update' do
      product.name = Product.last.name
      expect(product.valid?).must_equal true
    end

    it 'must have a description' do
      product.description = nil
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :description
    end

    it 'must have a unique description on create' do
      product = Product.new(name: 'test name',
                            description: Product.last.description,
                            price: 10,
                            quantity: 10
      )

      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :description
      expect(product.errors.messages[:description]).must_equal ['has already been taken']
    end

    it 'does not need a unique description on update' do
      product.name = Product.last.description
      expect(product.valid?).must_equal true
    end

    it 'must have a price' do
      product.price = nil
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :price
    end

    it 'must have a price greater than or equal to 0' do
      product.price = -90
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :price

      product.price = 0
      expect(product.valid?).must_equal true
    end

    it 'must have a quantity' do
      product.quantity = nil
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :quantity
    end

    it 'must have a quantity greater than or equal to 0' do
      product.quantity = -80
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :quantity

      product.quantity = 0
      expect(product.valid?).must_equal true
    end
  end

  describe 'custom methods' do
    describe 'toggle_retire' do
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

  describe 'average_rating' do
    it 'can calculate the average rating for product reviews' do
      review1
      review2

      expect(product.average_rating).must_equal 4
    end

    it 'will return nil if there are no product reviews' do
      assert_nil(product.average_rating)
    end
  end
end
