class AddSendersColumnsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :sender_name, :string
    add_column :orders, :sender_phone, :string
  end
end
