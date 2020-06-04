class SubCategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def show
    @sub_category = SubCategory.find_by(slug: params[:slug])
    @products = @sub_category.products.where(published: true)
  end
end
