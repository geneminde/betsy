class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def average_rating
    total_ratings = self.reviews.sum(:rating)
    total_items = self.reviews.count(:rating)

    return nil if total_ratings.blank? || total_items.blank?

    avg_rating = total_ratings / total_items

    return avg_rating
  end
end
