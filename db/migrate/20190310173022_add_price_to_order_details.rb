class AddPriceToOrderDetails < ActiveRecord::Migration[5.1]
  def change
    add_monetize :order_details, :price, currency: { present: false }
  end
end
