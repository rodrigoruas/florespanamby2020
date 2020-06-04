class DeliveryCost < ApplicationRecord
  monetize :price_cents
  has_many :orders
  validates :name, :min_distance, :max_distance, :multiplier, presence: true
  scope :bigger_than, -> (distance) {where("min_distance > ?", distance)}
  scope :smaller_than, -> (distance) {where("max_distance < ?", distance)}

  def weekday
    if weekend?
      "Final de Semana"
    else
      "Dia de Semana"
    end
  end

  def self.display_delivery_costs(delivery_date, distance)
    DeliveryCost.where(["max_distance > ?", distance])
  end  
  
  def get_price(delivery_distance)
    cost = delivery_distance * multiplier
    if cost < 10
      return 10
    else
      return cost.ceil
    end
  end
end
