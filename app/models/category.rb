class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true

  def active_products
    return self.products.where(is_retired: false)
  end
end
