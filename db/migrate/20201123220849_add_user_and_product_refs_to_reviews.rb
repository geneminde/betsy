class AddUserAndProductRefsToReviews < ActiveRecord::Migration[6.0]
  def change
    add_reference :reviews, :user, index: true
    add_reference :reviews, :product, index: true
  end
end
