desc "Add Featured to Products"
namespace :products do
  task :update_featured => :environment do
    products = Product.all
    products.each do |prod|
      p prod.id
      prod.featured = false
      prod.save
    end
  end
end
