class AddPaymentToSpecialOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :special_orders, :payment, :jsonb
  end
end
