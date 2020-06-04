class AddParamNameToSubCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :sub_categories, :param_name, :string
  end
end
