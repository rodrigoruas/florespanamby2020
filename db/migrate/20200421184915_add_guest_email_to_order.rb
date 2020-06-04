class AddGuestEmailToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :guest_email, :string
  end
end
