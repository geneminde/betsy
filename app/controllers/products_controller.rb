class ProductsController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    @products = Product.all
  end
end