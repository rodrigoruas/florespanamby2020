class CreateSpecialOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :special_orders do |t|
      t.string :description
      t.string :customer_name
      t.string :customer_email

      t.timestamps
    end
  end
end
