class OrderDetail < ApplicationRecord
  belongs_to :product
  monetize :price_cents
  belongs_to :user
  validates :quantity, :numericality => { :greater_than => 0 }, presence: true
end
