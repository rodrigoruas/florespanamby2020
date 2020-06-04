class AddDeliveryPriceToOrders < ActiveRecord::Migration[5.1]
  def change
    add_monetize :orders, :delivery_price, currency: { present: false }
  end
end
