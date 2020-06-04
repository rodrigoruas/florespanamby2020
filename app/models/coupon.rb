require 'readable_code'

class Coupon < ApplicationRecord
  DEFAULT_SIZE = 8
  DEFAULT_VALIDITY_DAYS = 45

  belongs_to :order, optional: true

  validates :code, :valid_until, :discount_percentage, presence: true

  validates :discount_percentage,
            numericality: {
              only_integer: true, greater_than: -1, less_than: 101 }

  before_validation :set_code_and_validity

  def valid
    if order_id == nil && valid_until > Time.now
      true
    else
      false
    end
  end

  def price
    (self.order.default_price - self.order.delivery_price) * (1 - discount_percentage.to_f / 100)
  end

  private

  def set_code_and_validity
    self.code = ReadableCode.generate(DEFAULT_SIZE) if code.blank?
    self.valid_until = Date.today + DEFAULT_VALIDITY_DAYS if valid_until.blank?
  end
end
