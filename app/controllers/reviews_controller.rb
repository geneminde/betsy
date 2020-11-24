class ReviewsController < ApplicationController
  skip_before_action :require_login
  before_action :find_product
  before_action :verify_auth_review

  def review_error
    flash.now[:error] = 'Uh oh! That review did not save. Please try again.'
  end

  ##################################################

  def new
    @review = @product.reviews.new
  end

  def create
    @review = @product.reviews.new(review_params)

    if @review.save
      redirect_to product_path(@review.product)
      return
    else
      # binding.pry
      review_error
      render :new
      # binding.pry
      # raise
      return
    end
  end

  private

  def review_params
    return params.require(:review).permit(:rating, :review_text, :author_name, :user_id, :product_id)
  end

  def verify_auth_review
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      if user.check_own_product(@product)
        flash[:error] = 'You cannot review your own product.'
        redirect_back(fallback_location: product_path(@product.id))
      end
    end
  end

end