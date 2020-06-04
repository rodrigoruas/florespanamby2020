class AddStateToSpecialOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :special_orders, :state, :string, default: "pending"
  end
end
