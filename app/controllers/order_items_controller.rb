class OrderItemsController < ApplicationController
  before_action :find_orderitem, only: [:update, :destroy]

  # Add item to order/cart
  def create
    @product = Product.find_by(id: params[:product_id])

    check_stock(@product)

    # If order/cart has not been created
    if @current_order.nil?
      @current_order = Order.new()
      @orderitem = Orderitem.new(product: @product)
      @current_order.orderitems << @orderitem

      if @current_order.save
        session[:order_id] = @current_order.id
        save_item_to_cart
      end
    # If order has been created with items in cart
    else
      @orderitem = OrderItem.new(order: @current_order, product: @product)
      save_item_to_cart
    end
  end


# Update quantity of item in order/cart
  def update
    check_stock(@orderitem.product)

    if @orderitem.update(orderitem_params)
      flash[:success] = "Successfully updated cart"
      redirect_back(fallback_location: root_path)
      return
    else
      flash[:error] = "A problem occurred. Could not update item in cart"
      flash[:validation_error] = @orderitem.errors.messages
      redirect_back(fallback_location: root_path)
      return
  end

  # Remove item from order/cart
  def destroy
    if @orderitem.destroy
      flash[:success] = "Successfully removed item from cart"
      redirect_back(fallback_location: root_path)
      return
    else
      flash[:error] = "A problem occurred. Could not remove item from cart"
      flash[:validation_error] = @orderitem.errors.messages
      redirect_back(fallback_location: root_path)
      return
    end
  end


  private

  def orderitem_params
    return params.require(:orderitems).permit(:quantity, :order, :product)
  end

  def find_orderitem
    @orderitem = Orderitem.find_by(id: params[:id])

    if @orderitem.nil?
      flash[:error] = "A problem occured. Order item not found"
      redirect_back(fallback_location: root_path)
    end
  end

  def save_item_to_cart
    if @orderitem.save
      flash[:success] = "#{@orderitem.product.name} added to the shopping cart"
      redirect_to order_path(@orderitem.order)
      return
    else
      flash[:error] = "A problem occurred. Could not add item to cart"
      flash[:validation_error] = @orderitem.errors.messages
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def check_stock(product)
    order_quantity = params[:quantity]

    # If quantity is 0 and Orderitem has been created / is in the cart, remove it from the cart
    if order_quantity == 0 && @orderitem
      destroy
      return
    end

    unless in_stock?(product, order_quantity)
      flash[:error] = "A problem occurred. #{product.name} was not added to the cart. Only #{product.quantity} available"
      redirect_back(fallback_location: root_path)
      return
    end
  end

end