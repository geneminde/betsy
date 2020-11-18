class ReplaceUserWithOrderInOrderItemTable < ActiveRecord::Migration[6.0]
  def change
    remove_reference :orderitems, :user, index: true
    add_reference :orderitems, :order, index: true
  end
end
