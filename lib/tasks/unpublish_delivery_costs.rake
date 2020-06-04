desc "Unpublish Delivery Costs"
namespace :delivery_costs do
  task :unpublish_all => :environment do
    delivery_costs = DeliveryCost.where(published: true)
    delivery_costs.each do |dc|
      p dc.id
      dc.published = false
      dc.save 
    end
  end
end
