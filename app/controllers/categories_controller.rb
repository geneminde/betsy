class CategoriesController < ApplicationController
  skip_before_action :require_login, only: [:show]
  before_action :find_category, only: [:show]


  def show
    if @category.nil?
      flash[:warning] = "Invalid category"
      redirect_to root_path
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "Category successfully created"
      redirect_to current_user_path
      return
    else
      flash.now[:error] = "Category not added"
      render :new, status: :bad_request
      return
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
  end
end
