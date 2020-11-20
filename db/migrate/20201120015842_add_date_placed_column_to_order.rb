class AddDatePlacedColumnToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :date_placed, :datetime
  end
end
