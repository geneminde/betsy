class OrdersController < ApplicationController
  skip_before_action :require_login
  before_action :find_order, only: [:show, :confirmation]

  def show
    @order = Order.find_by(id: params[:id])

    if @order.nil? || @order.empty_cart?
      redirect_to cart_path

    end
  end

  def edit
    @order = Order.find_by(id: session[:order_id])
    if @order.empty_cart?
      flash[:error] = "You must add an item to your cart.html.erb to checkout"
      redirect_to root_path
      return
    end
  end

  def update
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      flash[:warning] = "Cart empty"
    elsif @order.update(order_params)
      session[:order_id] = nil
      @order.mark_paid
      redirect_to order_confirmation_path(order_id: @order.id)
      return
    else
      flash.now[:error] = "Something went wrong while processing your order"
      render :edit, status: :bad_request
      return
    end
  end

  def confirmation
    @order = Order.find_by(id: params[:order_id])
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
