require 'test_helper'

describe ReviewsController do
  let(:user) { User.first }
  let(:product) { Product.first }

  let (:review1) {
    Review.create!(rating: 5, product_id: product.id)
  }

  let (:review2) {
    Review.create!(rating: 3, product_id: product.id)
  }

  describe 'signed-in user' do
    before do
      perform_login(user)
    end

    describe 'new' do
      it ''
    end

    describe 'create' do

    end
  end
end