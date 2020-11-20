class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :user, through: :products

  validates_presence_of :order, :product
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :cant_exceed_inventory

  def name
    return self.product.name
  end

  def subtotal
    return self.quantity * self.product.price if self.product
  end

  def sell(order_quantity)
    inventory_quantity = self.product.quantity
    if inventory_quantity > order_quantity
      self.product.quantity = inventory_quantity - order_quantity
    else
      return false
    end
  end

  def cant_exceed_inventory
    if self.product && self.quantity && ( self.quantity > self.product.quantity )
      errors.add(:quantity, "Cannot add #{self.quantity}. Only #{self.product.quantity} in stock")
    end
  end

  def already_in_cart?
    @cart = Order.find_by(id: session[:order_id])

    if @cart
      return @cart.products.include?(self.product)
    end
  end

  def mark_shipped
    self.shipped = true
    return self.save
  end
end
