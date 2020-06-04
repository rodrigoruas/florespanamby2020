class AddExceptionToDeliveryCost < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_costs, :exception, :datetime
  end
end
