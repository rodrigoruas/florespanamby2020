class AddColumnsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :width, :float
    add_column :products, :height, :float
    add_column :products, :depth, :float
  end
end
