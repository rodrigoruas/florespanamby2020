desc "Add Cities"
namespace :orders do
  task :update_city => :environment do
    orders = Order.where(["state = ? or state = ? or state = ? ", "paid", "delivered", "shipping"])
    orders.each do |order|
      if order.city == nil || order.city == ""
        order.city = "São Paulo"
        p order.city
        order.save
      end  
    end
  end
end
