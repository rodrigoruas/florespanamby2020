class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @category = Category.find_by(slug: params[:slug])
    if params[:sort] == "price_up"
      @products = @category.products.where(published: true)
    else
      @products = @category.products.where(published: true)
    end
  end
end
