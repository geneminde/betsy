class AddRetiredBoolToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :is_retired, :boolean
  end
end
