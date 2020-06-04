class FixDistanceColumnNameOnDeliveryCosts < ActiveRecord::Migration[5.1]
  def change
    rename_column :delivery_costs, :distance, :max_distance
    add_column :delivery_costs, :min_distance, :float
  end
end
