class AddWeekendToDeliveryCosts < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_costs, :weekend, :boolean, default: false
  end
end
