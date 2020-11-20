class OrderItemsController < ApplicationController
  skip_before_action :require_login
  before_action :find_order_item, only: [:update, :destroy, :ship]
  before_action :has_cart?, only: [:create, :update]
  before_action :consolidate_cart, only: [:create]

  # Add item to order/cart.html.erb
  def create
    @product = Product.find_by(id: params[:product_id])

    order_quantity = params[:quantity].to_i

    @order_item = OrderItem.new(product: @product, quantity: order_quantity)

    add_to_cart(@order_item)

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


<<<<<<< HEAD
# Update quantity of item in order/cart
=======
  # Update quantity of item in order/cart
>>>>>>> 3114fdf810fa3e44164dbdd6f65219f813caabf4
  def update
    save_update(@order_item)
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
<<<<<<< HEAD

  def ship
    if @order_item.mark_shipped
      flash[:success] = "#{@order_item.name} shipped"
    end
  end
=======
>>>>>>> 3114fdf810fa3e44164dbdd6f65219f813caabf4

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

  def add_to_cart(order_item)
    if @cart  # If order/cart has not been created
      order_item.order_id = @cart.id
    else  # If order has been created with items in cart
<<<<<<< HEAD
      order = Order.create()
      order.order_items << order_item
      session[:order_id] = order.id
=======
    order = Order.create()
    order.order_items << order_item
    session[:order_id] = order.id
>>>>>>> 3114fdf810fa3e44164dbdd6f65219f813caabf4
    end
  end

  def consolidate_cart
    @product = Product.find_by(id: params[:product_id])
<<<<<<< HEAD

    if @cart && @cart.products.include?(@product)
      existing_order_item = OrderItem.where(product: @product, order: @cart)

      # Modify the params hash to work with create and update actions
      params[:order_item] = { quantity: params[:quantity] }

=======

    if @cart && @cart.products.include?(@product)
      existing_order_item = OrderItem.where(product: @product, order: @cart)

      # Modify the params hash to work with create and update actions
      params[:order_item] = { quantity: params[:quantity] }

>>>>>>> 3114fdf810fa3e44164dbdd6f65219f813caabf4
      save_update(existing_order_item)
    end
  end

  def save_update(order_item)
    if @cart && order_item
      if order_item.update(quantity: params[:order_item][:quantity].to_i)
        flash[:success] = "Successfully updated order cart"
        redirect_to order_path(@cart.id)
        return
      else
        flash[:error] = "A problem occurred. Could not update item in cart"
        flash[:validation_error] = order_item.errors.messages
        redirect_back(fallback_location: root_path)
        return
      end
    else
      flash[:error] = "A problem occurred. Could not update item in cart"
      redirect_back(fallback_location: root_path)
      return
    end
  end
end