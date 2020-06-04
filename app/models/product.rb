class Product < ApplicationRecord
  monetize :price_cents
  monetize :fake_price_cents
  mount_uploader :photo, PhotoUploader
  has_many :order_details, dependent: :destroy
  has_and_belongs_to_many :sub_categories
  has_many :categories, through: :sub_categories
  has_many :product_attachments

  validates :short_description, length: { maximum: 60, too_long: "Máximo de %{count} caracteres" }, presence: true
  validates :name, length: { maximum: 30, too_long: "Máximo de %{count} caracteres" }, presence: true
  validates :description, :price, :photo, presence: true

  accepts_nested_attributes_for :product_attachments
  after_validation :set_slug, only: [:create, :update]

  include PgSearch::Model
  pg_search_scope :search_by_name_and_description,
  against: [ :name, :description ],
  using: {
    tsearch: { prefix: true }
  }

  pg_search_scope :search_by_name,
  against: [ :name],
  using: {
    tsearch: { prefix: true }
  }


  scope :ordered_by_name, -> {
    order('LOWER(name)')
  }

  def to_param
    slug
  end

  def self.sub_category_by_name(name)
    return joins(:sub_categories).where(:sub_categories => {:name => "#{name}"})
  end

  def self.ordered_by_price
    all.sort_by{|p| p.price}
  end

  def self.filter_max_price(p)
    where("price_cents < ?", p * 100).sort_by{|p| p.price}.reverse
  end

  def self.filter_min_price(p)
    where("price_cents > ?", p * 100).sort_by{|p| p.price}.reverse
  end

  private

  def set_slug
    self.slug = name.to_s.parameterize
  end
end
