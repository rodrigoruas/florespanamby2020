class Order < ApplicationRecord
  has_many :order_details, dependent: :nullify
  has_many :products, through: :order_details, dependent: :nullify
  belongs_to :user
  monetize :price_cents
  monetize :delivery_price_cents
  # geocoded_by :address
  # after_validation :geocode
  # after_save :geocode
  belongs_to :delivery_cost, optional: true, dependent: :destroy
  validates :delivery_date, :address, presence: true
  validates :street, :street_number, :zipcode, :delivery_date, :city, presence: true
  validates :delivery_distance, numericality: { less_than_or_equal_to: 100}
  validates :sender_name, presence: true, on: :update
  validates :guest_email, format: Devise.email_regexp, on: :update
  validates :guest_email, presence: true, on: :update
  has_one :coupon, dependent: :destroy

  scope :ordered_by_date, -> {
    order(delivery_date: :desc)
  }
  scope :ordered_by_created_date, -> {
    order(created_at: :desc)
  }

  scope :ordered_by_global_id, -> {
    order(global_id: :desc)
  }

  scope :ordered_by_name, -> {
    order(sender_name: :desc)
  }

  def calculate_distance
    loc2 = [longitude, latitude]
    loc1 = [-46.734693, -23.635113]
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters
  
    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg
  
    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }
    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    (rm * c / 1000.0).round(2)
  end


  def calculate_delivery
    if calculate_distance > 4
      "ok"
    else
      "ok tb"
    end
  end

  def delivery_cost_message
    if delivery_cost.nil?
      "frete a ser calculado"
    else
      "frete incluso"
    end
  end

  def state_translated
    if state == "pending"
      "Aguardando Pagamento"
    elsif state == "paid"
      "Pago"
    elsif state == "delivered"
      "Entregue"
    elsif state == "completed"
      "Completado"  
    elsif state == "shipping"
      "Em trânsito" 
    elsif state == "arquived"
      "Arquivado" 
    elsif state == "received"
      "Recebido"       
    end
  end

  def default_price
    price = 0
    order_details.each do |od|
      price =  price + od.price * od.quantity
    end
    price
  end

  def discount_price
    default_price * (1 - coupon.discount_percentage.to_f / 100)
  end

  def send_confirmation_mail
    OrderMailer.confirmed(self).deliver
    OrderMailer.confirmed_admin(self).deliver
    OrderMailer.confirmed_yasmin(self).deliver
    OrderMailer.confirmed_rodrigo(self).deliver
  end

  def send_shipping_mail
    OrderMailer.shipping(self).deliver
  end

  def email_to_user
    OrderMailer.confirmed(self).deliver
  end

  def send_sms
    t = TwilioSender.new(self)
    t.send_admin
  end

  def full_address
    "#{street},  #{street_number} -  #{complement} - #{zipcode}, #{neighborhood}, #{city}, #{uf} "
  end

  def self.last_paid
    self.where.not("state != ? or state != ?", "pending", "payment").last
  end

  def self.paid_orders
    self.where(["state = ? or state = ? or state = ? ", "paid", "delivered", "shipping"])
  end

  def get_products_price
    price = 0
    products.each do |prod|
      price += prod.price
    end
    price
  end

  private

end
