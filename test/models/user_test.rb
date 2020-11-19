require "test_helper"

describe User do
  let (:user) { User.first }

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

  end

  describe 'custom methods' do

  end
end
