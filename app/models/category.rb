class Category < ApplicationRecord
  has_many :sub_categories
  has_many :products, through: :sub_categories
  after_validation :set_slug, only: [:create, :update]
  # validates_uniqueness_of :navbar_order

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = name.to_s.parameterize
  end
end
