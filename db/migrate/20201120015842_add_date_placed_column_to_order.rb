class AddDatePlacedColumnToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :date_placed, :datetime,precision: 6, null: false
  end
end
