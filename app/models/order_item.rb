class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :merchant, through: :products

  validates_presence_of :order
  validates_presence_of :product

  validates :quantity, presence: true

  def subtotal
    return self.quantity * self.product.price
  end

  def sell(order_quantity)
    inventory_quantity = self.product.quantity
    if inventory_quantity > order_quantity
      self.product.quantity = inventory_quantity - order_quantity
    else
      return false
    end
  end

end
