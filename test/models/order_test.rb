require "test_helper"

describe Order do
  describe 'subtotal' do
    it 'returns the sum of the product prices in the cart' do
      order = orders(:order4)

      expect(order.subtotal).must_equal 5103
    end

    it 'returns 0 if there are no items in the cart' do
      order = Order.create(status: 'pending')

      expect(order.subtotal).must_equal 0
    end
  end
end
