require "test_helper"

describe Order do

    let (:empty_order) {
      Order.create(
          status: 'pending'
      )
    }
  describe 'subtotal' do

    it 'returns the sum of the product prices in the cart' do
      order = orders(:order4)

      expect(order.subtotal).must_equal 5103
    end

    it 'returns 0 if there are no items in the cart' do
      expect(empty_order.subtotal).must_equal 0
    end
  end

  describe 'empty_cart?' do
    it 'returns true if there are no items in the cart' do
      expect(empty_order.empty_cart?).must_equal true
    end

    it 'returns false if there are items in the cart' do
      order = orders(:order4)

      expect(order.empty_cart?).must_equal false
    end
  end
  describe 'mark_paid' do
    it 'changes the order status to "paid"' do
      order = empty_order

      order.mark_paid

      expect(order.status).must_equal "paid"
    end
  end
end

