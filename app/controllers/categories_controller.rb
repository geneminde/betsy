class CategoriesController < ApplicationController
  skip_before_action :require_login, except: [:new, :create, :edit, :update]

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
      redirect_to current_user_path
      return
    else
      flash.now[:error] = "Category not added"
      render :new, status: :bad_request
      return
    end
  end

  def edit
    @category = Category.find_by(id: params[:id])

    if @category.nil?
      flash[:error] = "Category does not exist"
      redirect_back(fallback_location: current_user_path)
      return
    end
  end

  def update
    @category = Category.find_by(id: params[:id])

    if @category.nil?
      flash[:error] = "Category does not exist"
      redirect_back(fallback_location: current_user_path)
      return
    elsif @category.update(category_params)
      flash[:success] = "#{@category.name.capitalize} updated successfully"
      redirect_to current_user_path
      return
    else
      flash.now[:error] = "Category not updated"
      render :edit, status: :bad_request
      return
    end
  end


  private

  def category_params
    return params.require(:category).permit(:name)
  end
end
