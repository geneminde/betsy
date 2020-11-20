class AddShippedColumnToOrderItem < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :shipped, :boolean, default: false
  end
end
