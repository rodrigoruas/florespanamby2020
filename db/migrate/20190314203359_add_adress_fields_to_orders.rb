class AddAdressFieldsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :neighborhood, :string
    add_column :orders, :city, :string
    add_column :orders, :uf, :string
    add_column :orders, :street_number, :string
    add_column :orders, :complement, :string
  end
end
