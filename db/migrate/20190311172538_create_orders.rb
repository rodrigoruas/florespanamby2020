class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :address
      t.date :delivery_date
      t.references :order_detail, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
