class AddNavbarOrderToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :navbar_order, :integer
  end
end
