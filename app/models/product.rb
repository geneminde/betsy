class Product < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user

  def in_stock?(order_quantity)
    self.quantity

    inventory_quantity = self.quantity
    return inventory_quantity > order_quantity
  end

end