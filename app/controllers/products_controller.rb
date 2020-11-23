class ProductsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  before_action :find_product, only: [:show, :edit, :retire, :update]

  def index
    @products = Product.all
  end

  def show; end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to current_user_path
      return
    else
      flash.now[:error] = "A problem occurred: Could not update #{@work.name}"
      render :edit
      return
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:success] = "Successfully created new #{@product.name}, \"for $#{@product.price}!\""
      redirect_to product_path(@product)
    else
      flash[:error] = "Product was NOT added"
      redirect_to new_product_path
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
    )
  end

  def find_product
    @product = Product.find_by(id: params[:id]) || Product.find_by(id: params[:product_id])
    if @product.nil?
      flash[:error] = 'Uh oh! That product could not be found... Please try again.'
      redirect_to products_path
    end
  end
end
