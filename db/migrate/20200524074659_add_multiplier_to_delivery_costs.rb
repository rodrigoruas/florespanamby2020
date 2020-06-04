class AddMultiplierToDeliveryCosts < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_costs, :multiplier, :float, default: 1.50
  end
end
