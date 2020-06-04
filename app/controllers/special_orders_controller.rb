class SpecialOrdersController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    @special_order = SpecialOrder.find(params[:id])
    @products = Product.all
  end
end
