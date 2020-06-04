desc "Update global orders id"
namespace :orders do
  task :update_global_id => :environment do
    orders = Order.order(id: :asc).where.not(state: "pending")
    orders.each_with_index do |order, index|
      global_id = index + 1
      puts "Current Order: #{order.id}"
      puts "Global id: #{global_id }"
      order.global_id = global_id 
      order.save
    end
  end
  task :update_old_orders => :environment do
    orders = Order.where.not(state: "pending")
    p orders.count
    orders.each do |order|
      p "Order: #{order.id}"
      order.sender_name = "Test" if order.sender_name == nil
      order.sender_phone = "test@test.com" if order.sender_phone == nil
      order.guest_email = "test@test.com" if order.guest_email == nil
      order.save
    end
  end
end
