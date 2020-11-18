class RenameOrderitems < ActiveRecord::Migration[6.0]
  def change
    rename_table :orderitems, :order_items
  end
end
