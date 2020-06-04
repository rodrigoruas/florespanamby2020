class RemoveOrderDetailFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_reference :orders, :order_detail, foreign_key: true
  end
end
