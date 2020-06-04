class AddZipCodeAndStreetToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :zipcode, :string
    add_column :orders, :street, :string
  end
end
