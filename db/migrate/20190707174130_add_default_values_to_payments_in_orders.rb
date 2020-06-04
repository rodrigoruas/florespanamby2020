class AddDefaultValuesToPaymentsInOrders < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :payment, :jsonb, default: {}
    change_column :orders, :payment_events, :jsonb, default: {}
  end
end
