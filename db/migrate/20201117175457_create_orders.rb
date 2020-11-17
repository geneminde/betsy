class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :customer_name
      t.string :shipping_address
      t.string :cardholder_name
      t.integer :cc_number
      t.string :cc_expiry
      t.integer :ccv
      t.integer :billing_zip

      t.timestamps
    end
  end
end
