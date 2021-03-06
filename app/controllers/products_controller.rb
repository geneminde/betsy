class ProductsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  before_action :find_product, only: [:show, :edit, :retire, :update]
  before_action :current_user, only: [:edit, :update, :create]
  before_action :verify_authorized, only: [:edit, :update, :retire]

  def index
    @products = Product.all
  end

  def show
    if @product.is_retired
      verify_authorized
    end
  end

  def edit; end

  def update
    @product.user = @current_user

    if @product.update(product_params)
      flash[:success] = "#{@product.name} updated successfully"
      redirect_to current_user_path
      return
    else
      flash.now[:error] = "A problem occurred: Could not update product: #{@product.name}"
      render :edit
      return
    end
  end

  def new
    @product = @current_user.products.new
  end

  def create
    @product = Product.new(product_params)
    @product.user = @current_user

    if @product.save
      flash[:success] = "Successfully created #{@product.name}"
      redirect_to product_path(@product)
    else
      flash.now[:error] = "Product was NOT added"
      render :new
    end
  end
  
  def retire
    @product.toggle_retire
    redirect_to current_user_path
  end

  private

  def product_params
    params.require(:product).permit(
        :name,
        :price,
        :photo_url,
        :description,
        :quantity,
        :available,
        category_ids: []
      )
  end

  def verify_authorized
    unless session[:user_id] && User.find_by(id: session[:user_id]).check_own_product(@product)
      flash[:error] = 'Uh oh! That product could not be found... Please try again.'
      redirect_back(fallback_location: products_path)
      return
    end
  end
end
