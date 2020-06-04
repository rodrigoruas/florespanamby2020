class AddAdminOrderToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :admin_order, :boolean, default: false
  end
end
