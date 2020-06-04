class AddSameDayDeliveryToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :same_day_delivery, :boolean, default: true
  end
end
