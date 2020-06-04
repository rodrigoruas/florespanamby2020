class AddColumnsToSearches < ActiveRecord::Migration[5.1]
  def change
    add_column :searches, :keywords, :string
    add_column :searches, :category_id, :integer
  end
end
