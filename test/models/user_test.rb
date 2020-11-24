require "test_helper"

describe User do
  let (:user) { User.first }
  let (:auth_hash) {
    {
        provider: 'github',
        uid: 123456,
        info: {
            email: 'test@test.com',
            name: 'testtest'
        }
    }
  }

  let (:product) {
    Product.create!(
      name: 'new_name',
      description: 'new_description',
      price: 29,
      quantity: 22,
      user_id: user.id
    )
  }

  let (:review1) {
    Review.create!(rating: 5, product_id: product.id)
  }

  let (:review2) {
    Review.create!(rating: 3, product_id: product.id)
  }

  it 'can be instantiated with the required fields' do
    expect(user.valid?).must_equal true

    %w[username email uid provider].each do |field|
      expect(user).must_respond_to field
    end
  end

  describe 'relationships' do
    it 'has many products' do
      expect(user.products.count).must_equal 1

      user.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end

    it 'has many order items through products' do
      expect(user.order_items.count).must_equal 2

      user.order_items.each do |order_item|
        expect(order_item).must_be_instance_of OrderItem
      end
    end

    it 'has many categories through products' do

    end

    it 'has many reviews through products' do
      review1
      review2

      expect(user.reviews.count).must_equal 2

      user.reviews.each do |review|
        expect(review).must_be_instance_of Review
      end
    end
  end

  describe 'validations' do
    it 'must have a uid' do
      user.uid = nil
      expect(user.valid?).must_equal false
      expect(user.errors.messages).must_include :uid
    end

    it 'must have a unique uid' do
      user.uid = User.last.uid

      expect(user.valid?).must_equal false
      expect(user.errors.messages).must_include :uid
      expect(user.errors.messages[:uid]).must_equal ['has already been taken']
    end

    it 'must have a username' do
      user.username = nil
      expect(user.valid?).must_equal false
      expect(user.errors.messages).must_include :username
    end

    it 'must have a unique username' do
      user.username = User.last.username

      expect(user.valid?).must_equal false
      expect(user.errors.messages).must_include :username
      expect(user.errors.messages[:username]).must_equal ['has already been taken']
    end

    it 'must have an email address' do
      user.email = nil
      expect(user.valid?).must_equal false
      expect(user.errors.messages).must_include :email
    end

    it 'must have a unique email address' do
      user.email = User.last.email

      expect(user.valid?).must_equal false
      expect(user.errors.messages).must_include :email
      expect(user.errors.messages[:email]).must_equal ['has already been taken']
    end
  end

  describe 'custom methods' do
    describe 'build_from_github' do
      it 'build_from_github: returns a user given a hash' do
        new_user = User.build_from_github(auth_hash)

        expect(new_user.username).must_equal auth_hash[:info][:name]
        expect(new_user.email).must_equal auth_hash[:info][:email]
        expect(new_user.uid).must_equal auth_hash[:uid]
        expect(new_user.provider).must_equal auth_hash[:provider]
      end
    end

    describe 'average_rating' do
      it 'can calculate the average rating for user products reviews' do
        review1
        review2

        expect(user.average_rating).must_equal 4
      end

      it 'will return nil if there are no user products reviews' do
        assert_nil(user.average_rating)
      end
    end

    describe 'check_own_product' do
      it 'will return true if the product belongs to the user' do
        product
        expect(user.check_own_product(product)).must_equal true
      end

      it 'will return false if the product does not belong to the user' do
        other_product = Product.create!(
          name: 'new_name',
          description: 'new_description',
          price: 29,
          quantity: 22,
          user_id: User.last.id
        )

        expect(user.check_own_product(other_product)).must_equal false
      end
    end
  end
end
