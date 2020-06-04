class AddNavbarToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :navbar, :boolean, default: false
  end
end
