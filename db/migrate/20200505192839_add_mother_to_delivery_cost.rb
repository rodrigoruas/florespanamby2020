class AddMotherToDeliveryCost < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_costs, :mother, :boolean, default: false
  end
end
