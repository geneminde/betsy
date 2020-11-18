class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :merchant, through: :products

  validates_presence_of :order
  validates_presence_of :product

  accepts_nested_attributes_for :order
  # def remove_orderitem
  #
  # end

  # Check if orderitem quantity is greater than product quantity
  # Should this be in product?
  def in_stock?(product, order_quantity)
    inventory_quantity = @product.quantity
    return inventory_quantity > order_quantity
  end

  # def sell(order_quantity)
  #   inventory_quantity = self.product.quantity
  #   if inventory_quantity > order_quantity
  #     self.product.quantity = inventory_quantity - order_quantity
  #   else
  #     raise ArgumentError
  # end
end
