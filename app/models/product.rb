class Product < ApplicationRecord
  before_save :set_availability

  has_many :order_items, dependent: :destroy
  belongs_to :user
  has_many :orders, through: :order_items
  has_and_belongs_to_many :categories
  has_many :reviews, dependent: :destroy

  validates :name, :description,
            uniqueness: true,
            on: :create

  validates :name, :description,
            presence: true

  validates :price, :quantity,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  def in_stock?(order_quantity)
    inventory_quantity = self.quantity
    return inventory_quantity > order_quantity
  end

  def available?
    self.quantity.positive? ? :available : :unavailable
  end

  def toggle_retire
    product = self
    product.is_retired = (product.is_retired == true ? false : true)

    unless product.is_retired
      product.available = true if product.quantity.positive?
      product.save
      return
    end

    product.available = false
    product.save
  end

  def set_availability
    product = self
    product.available = false if product.quantity.zero?
  end
end