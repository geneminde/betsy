require "test_helper"

describe OrderItemsController do
  before do
    @product = products(:product1)
    @order = orders(:order1)

    @order_item_hash = {
        quantity: 5,
        order: nil,
        product: @product
      }
  end

  describe "create" do
    it "creates an order item and order if no order is in session and redirects" do
      Order.destroy_all

      expect{
        post product_order_items_path(@product), params: @order_item_hash
      }.must_change "OrderItem.count", 1

      expect(Order.count).must_equal 1

      created_order_item = OrderItem.order(created_at: :desc).first
      created_order = Order.first

      expect(created_order_item.order).must_equal created_order
      expect(created_order_item.product).must_equal @order_item_hash[:product]
      expect(created_order_item.quantity).must_equal @order_item_hash[:quantity]

      expect(session[:order_id]).must_equal created_order.id
      must_respond_with :redirect
    end

    it "creates an order item in an existing order and redirects" do
      # Initiate an order by adding an order item
      post product_order_items_path(@product), params: @order_item_hash

      num_of_existing_orders = Order.count

      current_order = Order.find_by(id: session[:order_id])
      product_to_add = products(:product2)
      @order_item_hash[:product] = product_to_add

      expect{
        post product_order_items_path(product_to_add), params: @order_item_hash
      }.must_change "OrderItem.count", 1

      created_order_item = OrderItem.order(created_at: :desc).first

      expect(created_order_item.order).must_equal current_order
      expect(created_order_item.product).must_equal @order_item_hash[:product]
      expect(created_order_item.quantity).must_equal @order_item_hash[:quantity]
      expect(Order.count).must_equal num_of_existing_orders
      must_respond_with :redirect
    end

    it "does not create an order item if there is no product" do
      @order_item_hash[:product] = nil

      expect{
        post product_order_items_path(-1), params: @order_item_hash
      }.wont_change "OrderItem.count"
      must_respond_with :redirect
    end
  end

  describe "update" do
    before do
      @order_item = order_items(:order_item1)
      @order_item_hash[:order] = @order_item.order
      @order_item_hash[:product] = @order_item.product
    end

    it "updates existing order item in the cart and redirects" do
      @order_item_hash[:quantity] = 10

      expect{
        patch order_item_path(@order_item), params: @order_item_hash
      }.wont_change "OrderItem.count"

      @order_item.reload

      expect(@order_item.quantity).must_equal @order_item_hash[:quantity]
      must_respond_with :redirect
    end

    it "does not update if order item does not exist and redirects" do
      # Initiate an order by adding an order item
      expect{
        patch order_item_path(-1), params: @order_item_hash
      }.wont_change "OrderItem.count"

      must_respond_with :redirect
    end

    it "does not update if order item if quantity exceeds product quantity and redirects" do
      # Initiate an order by adding an order item
      product_quantity = @order_item.product.quantity
      @order_item_hash[:quantity] = product_quantity + 1

      expect{
        patch order_item_path(@order_item), params: @order_item_hash
      }.wont_change "OrderItem.count"

      must_respond_with :redirect
    end
  end

  describe "destroy" do
    it "destroys an existing order item and redirects" do
      order_item = order_items(:order_item1)

      expect{
        delete order_item_path(order_item)
      }.must_change "OrderItem.count", -1

      must_respond_with :redirect
    end

    it "does not change the database when order item doesn't exist and then redirects" do
      expect{
        delete order_item_path(-1)
      }.wont_change "OrderItem.count"

      must_respond_with :redirect
    end
  end
end
