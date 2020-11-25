class Order < ApplicationRecord
  STATUS = %w[pending paid complete cancelled]
  has_many :order_items
  has_many :products, through: :order_items

  validates :status, presence: true

  scope :user_orders, -> (user_id) { joins(:products).where(products: {user_id: user_id}).distinct }

  def subtotal
    self.order_items.inject(0) { |memo, item| memo + (item.product.price * item.quantity) }
  end

  def complete_order
    if self.status == "pending"
      self.status = "paid"
      self.order_items.each do |item|
        item.product.decrement!("quantity", item.quantity)
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

  def self.to_status_hash(user)
    orders_by_status_hash = {}

    STATUS.each do |status|
      unless status == "pending"
        orders_by_status_hash[status] = self.user_orders(user).by_status(status)
      end
    end

    return orders_by_status_hash
  end

  def self.by_status(status)
    return self.where(status: status).order(date_placed: :desc)
  end

  def items_subtotal(user)
    return self.filter_items(user).sum { |item| item.subtotal }
  end

  def self.total_revenue(user)
    orders = self.user_orders(user)

    return orders.sum { |order| order.items_subtotal(user) }
  end

end
