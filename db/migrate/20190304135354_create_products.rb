class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :short_description
      t.text :description

      t.timestamps
    end
  end
end
