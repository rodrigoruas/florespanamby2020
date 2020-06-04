class AddPaymentHashToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :payment_hash, :jsonb
  end
end
