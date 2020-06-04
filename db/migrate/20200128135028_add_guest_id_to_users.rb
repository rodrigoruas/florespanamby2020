class AddGuestIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :guest_id, :string
  end
end
