class AddPriceToSpecialOrders < ActiveRecord::Migration[5.1]
  def change
    add_monetize :special_orders, :price, currency: { present: false }
  end
end
