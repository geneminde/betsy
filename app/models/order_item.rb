class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :user, through: :product

  validates_presence_of :order, :product
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :cant_exceed_inventory

  validates_uniqueness_of :product, scope: :order, message: "Product has already been added to the cart. Items must be consolidated."
  
  def name
    return self.product.name
  end

  def subtotal
    return self.quantity * self.product.price if self.product
  end

  def cant_exceed_inventory
    if self.product && self.quantity && ( self.quantity > self.product.quantity )
      errors.add(:quantity, "Cannot add #{self.quantity}. Only #{self.product.quantity} in stock.")
    end
  end

  def mark_shipped
    self.shipped = true
    return self.save
  end
end
