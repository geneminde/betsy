class Product < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user
  has_many :orders, through: :order_items

  def in_stock?(order_quantity)
    self.quantity

    inventory_quantity = self.quantity
    return inventory_quantity > order_quantity
  end

  def available?
    self.quantity.positive? ? :available : :unavailable
  end
end