class ProductsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  before_action :current_user, only: [:index]
  before_action :find_product, only: [:show, :edit]


  def index
    @products = Product.all
  end

  def show;
    @user = User.find_by(id: params[:uid])
  end
  def edit; end

  private

  def product_params
    params.require(:product).permit(
        :name,
        :price,
        :photo_url,
        :description,
        :quantity,
        :available
    )
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash.now[:warning] = 'Oops? Try again!'
      render :notfound, status: not_found
    end
  end
end
