require "test_helper"

describe Review do
  let (:product) { Product.first }

  let (:review) {
    Review.create!(
        rating: 5,
        product_id: product.id
    )
  }

  it 'can be instantiated with the required fields' do
    expect(review.valid?).must_equal true

    %w[rating review_text author_name product_id].each do |field|
      expect(review).must_respond_to field
    end
  end

  describe 'relationships' do
    it 'belongs to a product' do
      review
      expect(product.reviews.count).must_equal 1

      product.reviews.each do |review|
        expect(review).must_be_instance_of Review
      end
    end
  end

  describe 'validations' do
    it 'must have a rating' do
      review.rating = nil
      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
    end

    it 'must have a rating between 1-5 inclusive' do
      review.rating = 0

      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
      expect(review.errors.messages[:rating]).must_include 'must be greater than 0'
      expect(review.errors.messages[:rating]).must_include 'Please provide a rating from 1-5.'
    end
  end
end
