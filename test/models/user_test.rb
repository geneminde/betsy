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
      expect(user.order_items.count).must_equal 1

      user.order_items.each do |order_item|
        expect(order_item).must_be_instance_of OrderItem
      end
    end

    it 'has many categories through products' do

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
    it 'build_from_github: returns a user given a hash' do
      new_user = User.build_from_github(auth_hash)

      expect(new_user.username).must_equal auth_hash[:info][:name]
      expect(new_user.email).must_equal auth_hash[:info][:email]
      expect(new_user.uid).must_equal auth_hash[:uid]
      expect(new_user.provider).must_equal auth_hash[:provider]
    end
  end
end
