class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :discount_percentage
      t.datetime :valid_until
      t.references :order, foreign_key: true
      t.timestamps
    end
  end
end
