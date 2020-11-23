require "test_helper"

describe Order do

  let (:empty_order) {
    Order.create(
        status: 'pending'
    )
  }

  describe 'subtotal' do
    it 'returns the sum of the product prices in the cart.html.erb' do
      order = orders(:order11)

      expect(order.subtotal).must_equal 6042
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

  describe 'complete_order' do
    it 'changes the order status to "paid"' do
      order = orders(:order11)

      order.complete_order

      expect(order.status).must_equal "paid"
    end


    it 'decrements ordered qty of each OrderItem from Product qty for a paid order' do
      product_inventory = []
      order = orders(:order11)
      order.order_items.each do |order_item|
        product_inventory << order_item.product.quantity
      end

      order.complete_order

      paid_order = orders(:order11)

      paid_order.order_items.each_with_index do |order_item, index|
        expect(order_item.product.quantity + order_item.quantity).must_equal product_inventory[index]
      end
    end

    it 'sets the date and time when the order was completed' do
      order = orders(:order11)
      order.complete_order
      date_completed = order.date_placed

      paid_order = orders(:order11)

      expect(paid_order.date_placed).must_equal date_completed
    end
  end

  describe 'mark_shipped' do
    it 'updates the order status to "shipped" if the individual order_items are all shipped' do
      order = orders(:order12)
      order.mark_shipped

      expect(order.status).must_equal "complete"
    end

    it 'does not update the order status to "shipped" if there is an unshipped order_item' do
      order = orders(:order13)
      order.mark_shipped

      expect(order.status).must_equal "paid"
    end
  end
end