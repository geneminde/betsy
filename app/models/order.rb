class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  scope :user_orders, -> (user_id) { joins(:products).where(products: {user_id: user_id}).distinct }

  def subtotal
    self.order_items.inject(0) { |memo, item| memo + (item.product.price * item.quantity) }
  end

  def empty_cart?
    self.order_items.blank? ? true : false
  end

  def complete_order
    if self.status == "pending"
      self.status = "paid"
      self.order_items.each do |item|
        item.product.decrement("quantity", item.quantity)
      end
      self.date_placed = DateTime.now
      self.save
    end
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
