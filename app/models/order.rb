class Order < ApplicationRecord
  has_many :order_items

  def subtotal
    self.order_items.inject(0) { |memo, item| memo + item.product.price }
  end

  def empty_cart?
    self.order_items.blank? ? true : false
  end
end
