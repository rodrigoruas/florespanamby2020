class CreateDeliveryCosts < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_costs do |t|
      t.string :name

      t.timestamps
    end
  end
end
