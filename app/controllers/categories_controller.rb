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

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "Category successfully created"
      redirect_to categories_path #Placeholder - we'll want to redirect somewhere more salient to the user
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
end
