class AddGlobalIdToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :global_id, :integer, unique: true
  end
end
