require 'products_controller'
RSpec.describe ProductsController, type: :controller do
  context 'GET #index' do
    it 'returns a sucess response' do
      get :index
      expect(response).to be_success
    end
  end
  context 'GET #show' do
    it 'returns a sucess response' do
      product = Product.create!(name: "Flower", short_description: "bla",
                                description: "bla bla", photo: File.open(File.join(Rails.root, '/spec/support/test.jpg')),
                                price_cents: 12000, slug: "flower")
      get :show, params: {slug: product.slug}
      expect(response).to be_success
    end
  end
  context 'GET #new' do
    it 'assign product to @product' do
      product = Product.new(name: "Flower", short_description: "bla",
                                description: "bla bla", photo: File.open(File.join(Rails.root, '/spec/support/test.jpg')),
                                price_cents: 12000, slug: "flower")
      get :show, params: {slug: product.slug}
      expect(response).to be_success
    end
  end
end
