class AddMoreColumnsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :transaction_id, :string
    add_column :orders, :recipient_name, :string
    add_column :orders, :recipient_phone, :string
  end
end
