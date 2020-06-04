desc "Edit delivery"
namespace :delivery_costs do
  task :add_exceptions => :environment do
    deliveries = DeliveryCost.all
    deliveries.each do |del|
      p del.id
      del.exception = Date.parse("01/01/2020")
      del.save
    end
  end
end