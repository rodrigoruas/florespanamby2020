class RemoveColumnsFromSpecialOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :special_orders, :description
    remove_column :special_orders, :customer_name
    remove_column :special_orders, :customer_email
    remove_column :special_orders, :price_cents
    remove_column :special_orders, :payment
    remove_column :special_orders, :state
  end
end
