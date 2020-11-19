class OrdersController < ApplicationController
  skip_before_action :require_login
  before_action :find_order, only: [:show, :confirmation]

  def show
    if @order.nil? || Order.empty_cart?(@order)
      redirect_to root_path
    end
  end

  def edit
    @order = session[:order_id]
    if @order.empty_cart?
      flash[:error] = "You must add an item to your cart.html.erb to checkout"
      redirect_to root_path
      return
    end
  end

  def update
    if @order.nil?
      flash[:warning] = "Cart empty"
    elsif @order.update(order_params)
      session[:order_id] = nil
      @order.mark_paid
      redirect_to order_confirmaiton_path
      return
    else
      flash.now[:error] = "Something went wrong while processing your order"
      render :edit, status: :bad_request
      return
    end
  end

  def confirmation
    if @order.nil?
      flash[:error] = "Something went wrong while processing your order"
      redirect_to root_path
    end
  end

  def cart; end

  private

  def find_order
    @order = Order.find_by(id: params[:id])
  end

  def order_params
    return params.require(:order).permit(:status, :customer_name, :shipping_address,
                                         :cardholder_name, :cc_number, :cc_expiry, :billing_zip)
  end

end
