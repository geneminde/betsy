require "test_helper"

describe OrderItemsController do
  before do
    @product = products(:product1)
    @order = orders(:order1)
    @order_item = order_items(:order_item1)

    @order_item_data = {
        quantity: 5,
        order: nil,
        product: @product
      }
  end

  describe "create" do
    it "creates an order item and order if no order is in session and redirects" do
      Order.destroy_all

      expect{
        post product_order_items_path(@product), params: @order_item_data
      }.must_change "OrderItem.count", 1

      expect(Order.count).must_equal 1

      created_order_item = OrderItem.order(created_at: :desc).first
      created_order = Order.first

      expect(created_order_item.order).must_equal created_order
      expect(created_order_item.product).must_equal @order_item_data[:product]
      expect(created_order_item.quantity).must_equal @order_item_data[:quantity]

      expect(session[:order_id]).must_equal created_order.id
      must_respond_with :redirect
    end

    it "creates an order item in an existing order and redirects" do
      # Initiate an order by adding an order item
      post product_order_items_path(@product), params: @order_item_data

      num_of_existing_orders = Order.count

      current_order = Order.find_by(id: session[:order_id])
      product_to_add = products(:product2)
      @order_item_data[:product] = product_to_add

      expect{
        post product_order_items_path(product_to_add), params: @order_item_data
      }.must_change "OrderItem.count", 1

      created_order_item = OrderItem.order(created_at: :desc).first

      expect(created_order_item.order).must_equal current_order
      expect(created_order_item.product).must_equal @order_item_data[:product]
      expect(created_order_item.quantity).must_equal @order_item_data[:quantity]
      expect(Order.count).must_equal num_of_existing_orders
      must_respond_with :redirect
    end

    it "does not create an order item if there is no product" do
      @order_item_data[:product] = nil

      expect{
        post product_order_items_path(-1), params: @order_item_data
      }.wont_change "OrderItem.count"
      must_respond_with :redirect
    end

    it "does not create a new order item if an existing item of the product is already in the cart" do
      # Initiate an order by adding an order item
      post product_order_items_path(@product), params: @order_item_data

      @order_item_data[:quantity] = 2

      expect{
        post product_order_items_path(@product), params: @order_item_data
      }.wont_change "OrderItem.count"

      created_order_item = OrderItem.order(created_at: :desc).first

      expect(created_order_item.quantity).must_equal 2
    end
  end

  describe "update" do
    before do
      @order_item_hash = {
        order_item: {
          quantity: 5,
          order: nil,
          product: @product
        }
      }

      @order_item_hash[:order_item][:order] = @order_item.order
      @order_item_hash[:order_item][:product] = @order_item.product
    end

    it "updates existing order item in the cart and redirects" do
      # Initiate an order by adding an order item
      post product_order_items_path(@product), params: @order_item_hash

      @order_item_hash[:order_item][:quantity] = 10

      expect{
        patch order_item_path(@order_item), params: @order_item_hash
      }.wont_change "OrderItem.count"

      @order_item.reload

      expect(@order_item.quantity).must_equal @order_item_hash[:order_item][:quantity]
      must_respond_with :redirect
    end

    it "does not update if order item does not exist and redirects" do
      expect{
        patch order_item_path(-1), params: @order_item_hash
      }.wont_change "OrderItem.count"

      must_respond_with :redirect
    end

    it "does not update item if there's no cart and redirects" do
      expect{
        patch order_item_path(@order_item), params: @order_item_hash
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
      expect{
        delete order_item_path(@order_item)
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

  describe "ship" do
    before do
      @order_item.shipped = false
    end

    it "changes order item shipped status if item belongs to logged-in user, and redirects" do
      perform_login(@order_item.user)

      expect{
        patch ship_path(@order_item)
      }.wont_change "OrderItem.count"

      @order_item.reload

      expect(@order_item.shipped).must_equal true
      must_respond_with :redirect
    end

    it "doesn't change order item shipped status if item does NOT belong to logged-in user, and redirects" do
      perform_login()

      expect{
        patch ship_path(@order_item)
      }.wont_change "OrderItem.count"

      @order_item.reload

      expect(@order_item.shipped).must_equal false
      expect(flash[:error]).must_equal "You are not authorized to do that"
      must_respond_with :redirect
    end

    it "guest user (not logged in) can't ship an item and is redirected" do
      patch ship_path(@order_item)

      expect(flash[:error]).must_equal "Please log in to perform this action."
      must_respond_with :redirect
    end

    describe "check_order_complete" do
      before do
        # Initiate an order by adding an order item
        post product_order_items_path(@product), params: @order_item_data

        @created_order_item = OrderItem.order(created_at: :desc).first
        @created_order = Order.order(created_at: :desc).first

        user = @product.user # user 2

        perform_login(user)
      end
      it "returns flash message if order is complete (all items shipped)" do
        patch ship_path(@created_order_item)

        expect(flash[:notice]).must_equal "Order ##{@created_order.id} is completed"
      end

      it "returns flash message if order is not shared and is not complete" do
        # user 2 has product1 and product5
        OrderItem.create(quantity: 1, order: @created_order, product: products(:product5))

        patch ship_path(@created_order_item)

        expect(flash[:notice]).must_equal "Order ##{@created_order.id} has additional items pending shipment"
      end

      it "returns flash message if order is shared and is not complete" do
        # product2 is a different user
        OrderItem.create(quantity: 1, order: @created_order, product: products(:product2))

        patch ship_path(@created_order_item)

        expect(flash[:notice]).must_equal "Order ##{@created_order.id} is shared with other merchant(s) and has additional items pending shipment"
      end
    end
  end


end
