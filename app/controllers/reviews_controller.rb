class ReviewsController < ApplicationController
  skip_before_action :require_login, except: [:edit, :update, :destroy]
  before_action :find_review, except: [:index, :new, :create]

  ##################################################

  def index; end

  def show; end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def find_review
    @review = Review.find_by(id: params[:id]) || Product.find_by(id: params[:product_id])

    if @review.nil?
      flash[:error] = 'Uh oh! That review could not be found... Please try again.'
      redirect_to products_path
    end

    return @review
  end

end