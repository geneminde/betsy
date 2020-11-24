require 'test_helper'

describe ReviewsController do
  let(:user) { User.first }
  let(:product) { Product.first }
  let(:new_product) {
    Product.create!(
      name: 'new_name',
      description: 'new_description',
      price: 29,
      quantity: 22,
      user_id: user.id
    )
  }

  let(:new_product_2) {
    Product.create!(
        name: 'new_name_2',
        description: 'new_description_2',
        price: 29,
        quantity: 22,
        user_id: User.last.id
    )
  }

  let (:review_hash) {
    {
      review: {
        rating: 5,
        product_id: new_product.id
      }
    }
  }

  let (:review_hash_2) {
    {
        review: {
            rating: 5,
            product_id: new_product_2.id
        }
    }
  }

  let (:invalid_review_hash) {
    {
      review: {
        rating: -5,
        product_id: new_product.id
      }
    }
  }

  let (:review1) {
    Review.create!(rating: 5, product_id: product.id)
  }

  let (:review2) {
    Review.create!(rating: 3, product_id: product.id)
  }

  describe 'guest user' do
    describe 'new' do
      it 'responds with success' do
        get new_product_review_path(product)
        must_respond_with :success
      end
    end

    describe 'create' do
      it 'can create a new review with valid information and redirect' do
        expect {
          post product_reviews_path(new_product), params: review_hash
        }.must_change 'Review.count', 1

        review = Review.find_by(product_id: review_hash[:review][:product_id])
        expect(review.rating).must_equal review_hash[:review][:rating]
        expect(review.product_id).must_equal review_hash[:review][:product_id]

        must_respond_with :redirect
        must_redirect_to product_path(review.product)
      end

      it 'does not create a review if the form data violates Review validations' do
        expect {
          post product_reviews_path(new_product), params: invalid_review_hash
        }.wont_change 'Review.count'
      end
    end
  end

  describe 'signed-in user' do
    before do
      perform_login(user)
    end

    describe 'new' do
      it 'responds with success' do
        get new_product_review_path(product)
        must_respond_with :success
      end
    end

    describe 'create' do
      it 'can create a new review with valid information and redirect' do
        expect {
          post product_reviews_path(new_product_2), params: review_hash_2
        }.must_change 'Review.count', 1

        review = Review.find_by(product_id: review_hash_2[:review][:product_id])
        expect(review.rating).must_equal review_hash_2[:review][:rating]
        expect(review.product_id).must_equal review_hash_2[:review][:product_id]

        must_respond_with :redirect
        must_redirect_to product_path(review.product)
      end

      it 'does not create a review if the form data violates Review validations' do
        expect {
          post product_reviews_path(new_product), params: invalid_review_hash
        }.wont_change 'Review.count'
      end

      it 'does not allow a merchant to review their own products' do
        expect {
          post product_reviews_path(new_product), params: review_hash
        }.wont_change 'Review.count'
      end
    end
  end
end