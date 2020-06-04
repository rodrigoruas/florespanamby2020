class AddPaymentEventsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :payment_events, :jsonb
  end
end
