require "test_helper"

describe OrderItemsController do
  it "creates an order item and order if no order is in session and redirects" do
    Order.destroy_all

  end

  it "creates an order item in an existing order and redirects" do

  end

  it "does not create an order item if there is no product" do

  end

  it "updates"
end
