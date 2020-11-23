require "test_helper"

describe Order do

    let (:empty_order) {
      Order.create(
          status: 'pending'
      )
    }
  describe 'subtotal' do

    it 'returns the sum of the product prices in the cart.html.erb' do
      order = orders(:order4)

      expect(order.subtotal).must_equal 495
    end

    it 'returns 0 if there are no items in the cart.html.erb' do
      expect(empty_order.subtotal).must_equal 0
    end
  end

  describe 'empty_cart?' do
    it 'returns true if there are no items in the cart.html.erb' do
      expect(empty_order.empty_cart?).must_equal true
    end

    it 'returns false if there are items in the cart.html.erb' do
      order = orders(:order4)

      expect(order.empty_cart?).must_equal false
    end
  end
  describe 'mark_paid' do
    it 'changes the order status to "paid"' do
      empty_order

      empty_order.mark_paid

      order = Order.find_by_id(empty_order.id)
      expect(order.status).must_equal "paid"
    end
  end

  describe "filter_items(user)" do
    let(:order) {
      orders(:order1) # order1 fixture includes multiple order items fixtures (1 and 8) and user fixtures (users 6 and 3, respectively)
    }
    it "returns order items of one user from a shared order" do
      expect(order.order_items).must_include order_items(:order_item1) # user 6
      expect(order.order_items).must_include order_items(:order_item8) # user 3

      user6_items = order.filter_items(users(:user6))

      expect(user6_items).must_include order_items(:order_item1)
      expect(user6_items.count).must_equal 1
    end

    it "returns empty if there are no items from given user in an order" do
      user_items = order.filter_items(users(:user1))

      expect(user_items).must_be_empty
    end
  end

  describe "shared?" do
    it "returns true if an order is shared among multiple merchants" do
      order = orders(:order1) # order1 fixture includes multiple order items fixtures (1 and 8) and user fixtures (users 6 and 3, respectively)

      expect(order.shared?).must_equal true
    end

    it "returns false if an order only has products from one merchant" do
      order = orders(:order6) # order6 has order items (3 and 6) from same user

      expect(order.shared?).must_equal false
    end
  end
end
