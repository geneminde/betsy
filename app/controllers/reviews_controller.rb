class ReviewsController < ApplicationController
  skip_before_action :require_login, except: [:edit, :update, :destroy]
  before_action :find_product, only: [:new, :create, :update]
  before_action :find_product_review, except: [:new, :create]

  def review_error
    flash.now[:error] = 'Uh oh! That review did not save. Please try again.'
  end

  ##################################################

  def show; end

  def new
    @review = @product.reviews.new
  end

  def create
    @review = @product.reviews.new(review_params)
    if @review.save
      redirect_to product_path(@review.product)
    else
      review_error
      render :new
    end
  end

  def edit; end

  def update
    if @review.update(review_params)
      flash[:success] = 'Review successfully updated.'
      redirect_to product_path(@review.product)
    else
      review_error
      render :edit
    end
  end

  def destroy
    if @review.destroy
      flash[:success] = 'Review successfully removed.'
      redirect_to product_path(@product)
    else
      flash[:error] = 'Uh oh! That review did not get removed. Please try again.'
    end
  end

  private

  def find_product_review
    @review = Review.find(params[:id])

    if @review.nil?
      flash[:error] = 'Uh oh! That review could not be found... Please try again.'
      redirect_back(fallback_location: products_path)
    end

    @product = @review.product
  end

  def review_params
    return params.require(:product).permit(:rating, :review_text, :user_id, :product_id)
  end

end