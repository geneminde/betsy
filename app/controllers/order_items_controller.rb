class OrderItemsController < ApplicationController
  skip_before_action :require_login
  before_action :find_order_item, only: [:update, :destroy]

  # Add item to order/cart
  def create
    @product = Product.find_by(id: params[:product_id])
    order_quantity = params[:quantity].to_i

    if item_in_stock?(@product, order_quantity)
      @current_order = current_order

      # If order/cart has not been created
      if @current_order.nil?
        @new_order = Order.new()
        @order_item = OrderItem.new(product: @product, quantity: order_quantity)
        @new_order.order_items << @order_item

        if @new_order.save
          session[:order_id] = @new_order.id
        end
      # If order has been created with items in cart
      else
        @order_item = OrderItem.new(order: @current_order, product: @product, quantity: order_quantity)
      end

      save_item_to_cart
      puts "session order #{session[:order_id]}"
    else
      redirect_back(fallback_location: root_path)
      return
    end
  end


# Update quantity of item in order/cart
  def update
    @current_order = current_order

    puts "order item quantity before update #{@order_item.quantity} for order #{@order_item.order.id}"

    order_quantity = params[:order_item][:quantity].to_i

    item_in_stock?(@order_item.product, order_quantity)

    if @order_item.update(quantity: params[:order_item][:quantity])
      flash[:success] = "Successfully updated order cart"
      puts "after update"
      puts "order item quantity #{@order_item.quantity} for order #{@order_item.order.id} "
      puts "updating order id #{@order_item.order.id}"
      puts "session order_id #{session[:order_id]}"
      redirect_to order_path(@order_item.order)
    else
      flash[:error] = "A problem occurred. Could not update item in cart"
      flash[:validation_error] = @order_item.errors.messages
      puts "can't update"
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

  # def order_item_params
  #   return params.require(:order_item).permit(:quantity, :order_id, :product_id)
  # end

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])

    if @order_item.nil?
      flash[:error] = "A problem occurred. Order item not found"
      redirect_back(fallback_location: root_path)
      return
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


  def item_in_stock?(product, order_quantity)
    if product.nil?
      flash[:error] = "A problem occurred. Could not update cart"
      puts "no product"
      return false
    end

    unless product.in_stock?(order_quantity)
      flash[:error] = "A problem occurred. #{product.name} was not added to the cart. Only #{product.quantity} available"
      puts "not in stock"
      return false
    end

    puts "in stock"
    return true
  end


end
