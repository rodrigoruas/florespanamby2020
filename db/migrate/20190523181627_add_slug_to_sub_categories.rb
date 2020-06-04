class AddSlugToSubCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :sub_categories, :slug, :string
  end
end
