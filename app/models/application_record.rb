class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def average_rating
    return nil if self.reviews.blank?

    total_ratings = self.reviews.sum(:rating)
    total_items = self.reviews.count(:rating)

    avg_rating = total_ratings.to_f / total_items

    return avg_rating.round(1)
  end
end
