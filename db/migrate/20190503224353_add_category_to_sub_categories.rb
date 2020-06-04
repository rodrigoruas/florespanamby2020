class AddCategoryToSubCategories < ActiveRecord::Migration[5.1]
  def change
    add_reference :sub_categories, :category, foreign_key: true
  end
end
