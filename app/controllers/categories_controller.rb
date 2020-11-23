class CategoriesController < ApplicationController
  skip_before_action :require_login, except: [:new]

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      flash[:warning] = "Invalid category"
      redirect_to root_path
    end
  end

  def new
    @category = Category.new
  end
end
