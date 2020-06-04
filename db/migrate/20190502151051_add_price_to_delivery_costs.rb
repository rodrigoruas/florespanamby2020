class AddPriceToDeliveryCosts < ActiveRecord::Migration[5.1]
  def change
    add_monetize :delivery_costs, :price, currency: { present: false }
  end
end
