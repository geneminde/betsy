class OrdersController < ApplicationController
  skip_before_action :require_login, except: [:index, :merchant_order]
  before_action :find_order, only: [:merchant_order, :confirmation]


  def index
    @orders_by_status = Order.to_status_hash(@current_user)
  end

  def merchant_order; end

  def edit
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      flash[:error] = "You must add an item to your cart to checkout"
      redirect_to root_path
      return
    end
  end

  def update
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      flash[:warning] = "Cart empty"
      redirect_to cart_path
      return
    elsif @order.update(order_params)
      @order.complete_order
      redirect_to order_confirmation_path(order_id: @order.id)
      return
    else
      flash.now[:error] = "Something went wrong while processing your order"
      render :edit, status: :bad_request
      return
    end
  end

  def confirmation
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      flash[:error] = "You cannot view this order"
      redirect_to root_path
    elsif @order.status != "paid"
      flash[:error] = "This order has not been completed"
      redirect_to root_path
    else
      session[:order_id] = nil
    end
  end

  def cart
    @order = Order.find_by(id: session[:order_id])
  end
  
  private

  def find_order
    @order = Order.find_by(id: params[:id])
  end

  def order_params
    return params.require(:order).permit(:status, :customer_name, :shipping_address,
                                         :cardholder_name, :cc_number, :cc_expiry, :billing_zip)
  end

end
