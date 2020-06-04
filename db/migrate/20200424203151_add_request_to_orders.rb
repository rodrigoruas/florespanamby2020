class AddRequestToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :request, :string
  end
end
