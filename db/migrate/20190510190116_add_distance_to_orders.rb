class AddDistanceToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :delivery_distance, :float
  end
end
