class SubCategory < ApplicationRecord
  has_and_belongs_to_many :products
  belongs_to :category

  after_validation :set_slug, only: [:create, :update]
  scope :ordered_by_name, -> {
    order(name: :asc)
  }

  def to_param
    slug
  end

  def self.first_half
    first(self.all.length / 2)
  end

  def self.last_half
    last(self.all.length / 2)
  end

  private

  def set_slug
    self.slug = name.to_s.parameterize
  end
end
