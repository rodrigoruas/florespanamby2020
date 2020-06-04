class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  def home
    # @mapbox = set_mapbox_token
    @markers = [
      {
        lat: -23.635685,
        lng:  -46.734599,
        infoWindow: render_to_string(partial: "info_window")
      }
      ]
    category = Category.find_by(slug: "flores")
    if @category.nil?
      @category = Category.where(navbar: true).first
    end
    @products = @category.products.where(published: true)
  end

  def about
  end

  def terms
  end

  def mothers
    sub_category = SubCategory.find_by(slug: "dia-das-maes")
    @products = sub_category.products.where(published: true).shuffle.first(10)
  end

  def promo
    @products = Product.where(published: true).filter_max_price(100).sort_by{|prod| prod[:price_cents]}
  end
end

