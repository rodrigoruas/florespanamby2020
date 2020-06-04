require 'rails_helper'
RSpec.describe Product, type: :model do
  # it { is_expected.to have_many(:categories) }
  context 'validation_tests' do
    let(:product) { build(:product)}
    it 'ensures name presence' do
      product.name = nil
      expect(product.save).to eq(false)
    end
    it 'ensures short description presence' do
      product.short_description = nil
      expect(product.save).to eq(false)
    end
    it 'ensures description presence' do
      product.description = nil
      expect(product.save).to eq(false)
    end
    it 'ensures photo presence' do
      product.photo = nil
      expect(product.save).to eq(false)
    end
    it 'should save successfully' do
      expect(product.save).to eq(true)
    end
  end
end
