class AddDeliveryCostToOrders < ActiveRecord::Migration[5.1]
  def change
     add_reference :orders, :delivery_cost, foreign_key: true
  end
end
