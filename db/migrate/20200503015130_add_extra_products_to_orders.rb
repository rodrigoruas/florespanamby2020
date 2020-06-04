class AddExtraProductsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :extra_products, :string
  end
end
