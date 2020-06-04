class CreateSubCategoriesProductsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :sub_categories, :products do |t|
      t.index :sub_category_id
      t.index :product_id
    end
  end
end
