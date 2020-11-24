class OrderItemsController < ApplicationController
  skip_before_action :require_login, except: [:ship]
  before_action :find_order_item, only: [:update, :destroy, :ship]
  before_action :has_cart?, only: [:create, :update]
  before_action :consolidate_cart, only: [:create, :update]

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
      flash_validation_errors(@order_item)
      redirect_back(fallback_location: root_path)
      return
    end
  end


  # Update quantity of item in order/cart
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
      flash_validation_errors(@order_item)
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def ship
    if authorized_user

      if @order_item.mark_shipped
        flash[:success] = "Order ##{@order_item.order.id}: #{@order_item.name} shipped"
        check_order_completed
      else
        flash[:error] = "Order ##{@order_item.order.id}: #{@order_item.name} could not be shipped"
      end

    end

    redirect_back(fallback_location: root_path)
    return
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

  def add_to_cart(order_item)
    if @cart  # If order/cart has not been created
      order_item.order_id = @cart.id
    else  # If order has been created with items in cart

      order = Order.create(status: "pending")
      order.order_items << order_item
      session[:order_id] = order.id
    end
  end

  def consolidate_cart
    @product = Product.find_by(id: params[:product_id])

    if @cart && @cart.products.include?(@product)
      existing_order_item = OrderItem.find_by(product: @product, order: @cart)

      # Modify the params hash to work with create and update actions
      params[:order_item] = { quantity: params[:quantity] }

      save_update(existing_order_item)
    end
  end

  def save_update(order_item)
    if @cart && order_item
      if order_item.update(quantity: params[:order_item][:quantity].to_i)
        flash[:success] = "Successfully updated order cart"
        puts "in save update"
        redirect_to order_path(@cart.id)
        return
      else
        flash[:error] = "A problem occurred. Could not update item in cart"
        flash_validation_errors(order_item)
        redirect_back(fallback_location: root_path)
        return
      end
    else
      flash[:error] = "A problem occurred. Could not update item in cart"
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def check_order_completed
    if @order_item.order.mark_shipped
      flash[:notice] = "Order ##{@order_item.order.id} is completed"
    else
      if @order_item.order.shared?
        flash[:notice] = "Order ##{@order_item.order.id} is shared with other merchant(s) and has additional items pending shipment"
      else
        flash[:notice] = "Order ##{@order_item.order.id} has additional items pending shipment"
      end
    end
  end

  def authorized_user
    if @current_user == @order_item.user
      return true
    else
      flash[:error] = "You are not authorized to do that"
      return false
    end
  end
end