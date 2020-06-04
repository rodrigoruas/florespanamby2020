class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    @products = Product.where(published: true)
    if params.present?
      if params[:query].present?
        sql_query = "name ILIKE :query OR description ILIKE :query"
        @products = Product.search_by_name_and_description(params[:query])
      elsif params[:sort].present?
        @products = @products.ordered_by_price
      elsif params[:max_price].present?
        @products = @products.filter_max_price(params[:max_price].to_f)
      elsif params[:search].present?
        @products = @products.search_by_name_and_description(params[:search])
        respond_to do |format|
          format.js
        end  
      else
        @products = @products.filter_min_price(100).sort_by{|prod| prod[:price_cents]}
      end
      @featured_products = Product.where(featured: true)
    end
  end

  def search_results
  end

  def show
    @product = Product.find_by(slug: params[:slug])
    @order_detail = OrderDetail.new
    # @disable_footer = true
  end
end