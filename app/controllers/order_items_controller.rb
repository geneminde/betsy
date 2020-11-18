class OrderItemsController < ApplicationController
  before_action :find_orderitem, only: [:update, :destroy]

  # Add item to order/cart
  def create
    @current_order = Order.find_by(id: session[:order_id])

    # If order/cart has not been created
    if @current_order.nil?
      @current_order = Order.create() # validate presence of :rderitem except when creating the order??
      session[:order_id] = @current_order.id
    end

    @product = Product.find_by(id: params[:product_id])

    @orderitem = OrderItem.new(order: @current_order, product: @product)

    if @orderitem.save
      flash[:success] = "#{orderitem.product.name} added to the shopping cart"
      redirect_to order_path(@current_order)
      return
    else
      flash[:error] = "A problem occurred. Could not add item to cart"
      flash[:validation_error] = @orderitem.errors.messages
      redirect_back(fallback_location: root_path)
      return
    end
  end


# Update quantity of item in order/cart
  def update
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
    else
      flash[:error] = "A problem occurred. Could not remove item from cart"
      flash[:validation_error] = @orderitem.errors.messages
      redirect_back(fallback_location: root_path)
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
end
