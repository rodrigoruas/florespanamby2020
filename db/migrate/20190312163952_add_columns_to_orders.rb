class AddColumnsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :order_sku, :string
    add_column :orders, :payment, :jsonb
    add_column :orders, :state, :string
  end
end
