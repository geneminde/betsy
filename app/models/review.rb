class Review < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :product

  validates :rating,
            presence: true,
            numericality: { greater_than: 0 },
            inclusion: {
                in: 1..5,
                message: 'Please provide a rating from 1-5.'
            }
end
