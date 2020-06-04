class AddPublishedToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :published, :boolean, default: true
  end
end
