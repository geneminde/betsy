class OrderItemsController < ApplicationController
  skip_before_action :require_login
  before_action :find_order_item, only: [:update, :destroy]

  # Add item to order/cart
  def create
    puts params

    @product = Product.find_by(id: params[:product_id])

    check_stock(@product)

    # If order/cart has not been created
    if @current_order.nil?
      @current_order = Order.new()
      @order_item = OrderItem.new(product: @product)
      @current_order.order_items << @order_item

      if @current_order.save
        session[:order_id] = @current_order.id
        save_item_to_cart
      end
    # If order has been created with items in cart
    else
      @order_item = OrderItem.new(order: @current_order, product: @product)
      save_item_to_cart
    end
  end


# Update quantity of item in order/cart
  def update
    check_stock(@order_item.product)

    if @order_item.update(order_item_params)
      flash[:success] = "Successfully updated cart"
      redirect_back(fallback_location: root_path)
      return
    else
      flash[:error] = "A problem occurred. Could not update item in cart"
      flash[:validation_error] = @order_item.errors.messages
      redirect_back(fallback_location: root_path)
      return
    end
  end

  # Remove item from order/cart
  def destroy
    if @order_item.destroy
      flash[:success] = "Successfully removed item from cart"
      redirect_back(fallback_location: root_path)
      return
    else
      flash[:error] = "A problem occurred. Could not remove item from cart"
      flash[:validation_error] = @order_item.errors.messages
      redirect_back(fallback_location: root_path)
      return
    end
  end


  private

  def order_item_params
    return params.require(:order_items).permit(:quantity, :order, :product)
  end

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])

    if @order_item.nil?
      flash[:error] = "A problem occured. Order item not found"
      redirect_back(fallback_location: root_path)
    end
  end

  def save_item_to_cart
    if @order_item.save
      flash[:success] = "#{@order_item.product.name} added to the shopping cart"
      redirect_to order_path(@order_item.order)
      return
    else
      flash[:error] = "A problem occurred. Could not add item to cart"
      flash[:validation_error] = @order_item.errors.messages
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def check_stock(product)
    order_quantity = params[:order_item][:quantity].to_i


    # If quantity is 0 and OrderItem has been created / is in the cart, remove it from the cart
    if order_quantity == 0 && @order_item
      destroy
      return
    end

    unless product.in_stock?(order_quantity)
      flash[:error] = "A problem occurred. #{product.name} was not added to the cart. Only #{product.quantity} available"
      redirect_back(fallback_location: root_path)
      return
    end
  end

end
