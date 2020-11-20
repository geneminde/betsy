class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  scope :user_orders, -> (user_id) { joins(:products).where(products: {user_id: user_id}) }

  def subtotal
    self.order_items.inject(0) { |memo, item| memo + (item.product.price * item.quantity) }
  end

  def empty_cart?
    self.order_items.blank? ? true : false
  end

  def mark_paid
    self.status = "paid"
    self.save
  end

  def mark_shipped
    items = self.order_items.where(shipped: true)
    if items.blank?
      self.status = "complete"
      self.save
    end
  end

  def decrement_inv
    if self.status == "paid"
      self.order_items.each do |item|
        product = item.product
        product.quantity -= item.quantity
        product.save
      end
    end
  end
end
