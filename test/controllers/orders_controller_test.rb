require "test_helper"

describe OrdersController do
  describe "index" do
    it "responds with success if user is logged in" do
      user = perform_login()

      get orders_path

      must_respond_with :success
    end

    it "responds with redirect if user is not logged in" do
      get orders_path

      expect(flash[:error]).must_include "Please log in to perform this action."
      must_redirect_to root_path
    end
  end

  describe 'show' do
    it 'it gets the cart page when an active cart exists' do
      order = create_cart

      get order_path(order.id)

      must_respond_with :success
    end

    it 'it gets an empty cart page for empty carts/invalid ids' do
      order_id = -1

      get order_path(order_id)
      must_redirect_to cart_path
    end
  end

  describe 'edit' do
    it 'gets the checkout page if there are items in the cart' do
      order = create_cart

      get edit_order_path(order.id)

      must_respond_with :success

    end

    it 'redirects to the root_path if there are no items in the cart' do
      order = orders(:order3)

      get edit_order_path(order.id)

      must_redirect_to root_path
    end
  end

  describe 'update' do
    let (:payment_info) {
      { order: {
          customer_name: "Customer",
          shipping_address: "1234 Pleasant Driver, Anywhere, WA 99999",
          cardholder_name: "Customer",
          cc_number: 1234,
          cc_expiry: "12/2022",
          ccv: 123,
          billing_zip: 99999
        }
      }
    }

    it 'updates the order with with a valid post request' do
      order = create_cart
      order_id = order.id

      expect {
        patch order_path(order_id), params: payment_info
      }.wont_change "Order.count"

      must_redirect_to order_confirmation_path(order_id)

      paid_order = Order.find_by(id: order_id)
      expect(paid_order.billing_zip).must_equal 99999

    end


    it 'respond with redirect for invalid order ids' do

      patch order_path(-1), params: payment_info

      must_redirect_to cart_path
    end

    it 'will not update the order for invalid inputs' do

    end
  end

  describe 'confirmation' do
    it 'shows the confirmation page for a completed transaction' do
      order = create_cart
      order.update({status: "paid"})
      order_id = order.id

      get order_confirmation_path(order_id)

      must_respond_with :success
    end

    it 'redirects to root_path if a cart is not in session' do
      order = orders(:order3)
      order_id = order.id

      get order_confirmation_path(order_id)

      must_redirect_to root_path
    end

    it 'redirects to root_path if an order is not paid' do
      order = create_cart
      order_id = order.id

      get order_confirmation_path(order_id)

      must_redirect_to root_path
    end
  end
end
