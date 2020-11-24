require "test_helper"

describe Product do
  let (:product) { Product.first }
  let (:user) { User.first }

  let (:review1) {
    Review.create!(rating: 5, product_id: product.id)
  }

  let (:review2) {
    Review.create!(rating: 3, product_id: product.id)
  }

  let (:product2) {
    Product.create!(
      name: 'new_name',
      description: 'new_description',
      price: 29,
      quantity: 22,
      user_id: user.id
    )
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
        expect(product.available).must_equal false
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

  describe 'set_availability, which is completed upon save' do
    it 'will set available to false if quantity is 0 before save' do
      expect(product2.available).must_equal true
      expect(product2.is_retired).must_equal false

      product2.quantity = 0
      product2.save

      expect(product2.available).must_equal false
      expect(product2.is_retired).must_equal false
    end

    it 'will not set available to false if quantity is greater than 0 before save and is_retired is false' do
      expect(product2.is_retired).must_equal false

      product2.quantity = 32
      product2.save

      expect(product2.available).must_equal true
      expect(product2.is_retired).must_equal false
    end

    it 'will set available to false if quantity > 0 but is_retired true' do
      expect(product2.is_retired).must_equal false

      product2.quantity = 32
      product2.is_retired = true
      product2.save

      expect(product2.quantity.positive?).must_equal true
      expect(product2.available).must_equal false
      expect(product2.is_retired).must_equal true
    end

    it 'will set is_retired to false at product creation' do
      expect(product2.is_retired).must_equal false
    end

    it 'will not set is_retired to false upon save if is_retired is true' do
      expect(product2.is_retired).must_equal false

      product2.is_retired = true
      product2.save

      expect(product2.is_retired).must_equal true
    end
  end
end
