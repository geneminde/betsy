require "test_helper"

describe OrderItemsController do
  before do
    @product = products(:product1)
    @order_item_hash = {
      order_item: {
        quantity: 2,
        order_id: nil,
        product_id: @product.id
      }
    }
  end

  it "creates an order item and order if no order is in session and redirects" do
    Order.destroy_all

    expect{
      post product_order_items_path(@product), params: @order_item_hash
    }.must_change "OrderItem.count", 1
  end

  # it "creates an order item in an existing order and redirects" do
  #
  # end
  #
  # it "does not create an order item if there is no product" do
  #
  # end
  #
  # it "updates" do
  #
  # end
end

