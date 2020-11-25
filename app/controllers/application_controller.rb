class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :find_categories, :find_users

  def current_user
    return @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    if current_user.nil?
      flash[:error] = 'Please log in to perform this action.'
      redirect_to root_path
    end
  end

  def has_cart?
    return @cart = Order.find_by(id: session[:order_id])
  end

  def flash_validation_errors(model)
    if model.errors.messages
      model.errors.messages.each do |field, messages|
        messages.each do |message|
          flash[field] = "#{field.capitalize}: #{message}"
        end
      end
    end
  end

  def find_product
    @product = Product.find_by(id: params[:id]) || Product.find_by(id: params[:product_id])

    if @product.nil?
      flash[:error] = 'Uh oh! That product could not be found... Please try again.'
      redirect_back(fallback_location: products_path)
      return
    end

    return @product
  end

  private

  def find_categories
    @categories = Category.all
  end

  def find_users
    @users = User.all
  end



end