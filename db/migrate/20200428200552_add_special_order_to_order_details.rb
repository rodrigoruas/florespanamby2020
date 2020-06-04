class AddSpecialOrderToOrderDetails < ActiveRecord::Migration[5.1]
  def change
    add_reference :order_details, :special_order, foreign_key: true
  end
end
