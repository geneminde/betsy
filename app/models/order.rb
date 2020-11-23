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
    items = self.order_items.where(shipped: false)
    if items.blank?
      self.status = "complete"
      return self.save
    end
  end

  def filter_items(user)
    return OrderItem.where(order: self, product: Product.where(user: user))
  end

  def shared?
    order_products = self.products
    users = order_products.distinct.pluck(:user_id)
    return users.count > 1
  end
end
