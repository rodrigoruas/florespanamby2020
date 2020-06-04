class AddUserToOrderDetails < ActiveRecord::Migration[5.1]
  def change
    add_reference :order_details, :user, foreign_key: true
  end
end
