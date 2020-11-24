require "test_helper"

describe Order do

  let (:empty_order) {
    Order.create(
        status: 'pending'
    )
  }
  describe 'initialize' do

    it 'can be initialized' do
      order = Order.new
      expect(order.valid?).must_equal true
    end

    it 'will have the required fields' do

      order_fields = [:status, :customer_name, :shipping_address, :cardholder_name,
                      :cc_number, :cc_expiry, :ccv, :billing_zip, :date_placed]

      order_fields.each do |field|
        expect(empty_order).must_respond_to field
      end
    end

  end

  describe 'validations' do

  end

  describe 'relations' do
    it 'has many order_items' do
      order = orders(:order11)
      order.order_items.each do |item|
        expect(item).must_be_instance_of OrderItem
      end
    end

    it 'has many products through order_items' do
      order = orders(:order11)
      order.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end

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

  describe "self.to_status_hash(user)" do
    it "returns a hash of user's orders grouped by status" do
      user = users(:user1)
      orders = Order.to_status_hash(user)

      expect(Order.to_status_hash(user)).must_be_kind_of Hash

      valid_status = %w[pending paid complete cancelled]


      orders.each do |status, orders|
        expect(valid_status).must_include status

        orders.each do |order|
          expect(order).must_be_kind_of Order
          expect(order.products.pluck(:user_id)).must_include user.id
        end
      end
    end
  end
end

