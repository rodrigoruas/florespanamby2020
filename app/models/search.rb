class Search < ApplicationRecord
  # monetize :min_price_centavos, as: :min_price, allow_nil: true
  # monetize :max_price_centavos, as: :max_price, allow_nil: true

  def products
    find_products
  end

  private

  def find_products
    products = Product.order(:name)
    products = products.where("name ILIKE ? OR description ILIKE ?", "%#{keywords}%", "%#{keywords}%") if keywords.present?
    products = products.where(category_id: category_id) if category_id.present?
    products = products.where("price_cents >= ?",min_price_cents * 100) if min_price_cents.present?
    products = products.where("price_cents <= ?",max_price_cents * 100) if max_price_cents.present?
    products
  end
end
