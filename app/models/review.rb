class Review < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :product, counter_cache: true

  validates :rating,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 },
            inclusion: {
                in: 0..5,
                message: 'Please provide a rating from 0-5.'
            }
end
