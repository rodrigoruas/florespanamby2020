class AddLatAndLngToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :lat, :float
    add_column :orders, :lng, :float
  end
end
