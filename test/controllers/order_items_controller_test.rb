require "test_helper"

describe OrderItemsController do
  # before do
  #   @product = products(:product1)
  # end

  it "creates an order item and order if no order is in session and redirects" do
    # Order.destroy_all
    #
    # expect{
    #   post order_item_path, params: @order_item_hash
    # }.must_change "OrderItem.count"

    p Order.count
    p Product.count
    p OrderItem.count
    p User.count
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
