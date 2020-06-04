class AddPublishedToDeliveryCosts < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_costs, :published, :boolean, default: true
  end
end
