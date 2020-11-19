class OrdersController < ApplicationController

  def show
    order_id = session[:order_id]
    @order = Order.find_by(id: order_id)

    if @order.nil? || Order.empty_cart?(@order)
      redirect_to root_path
    end
  end


end
