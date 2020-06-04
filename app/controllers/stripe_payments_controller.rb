class StripePaymentsController < ApplicationController
  skip_before_action :authenticate_user!
  def new
    @order = Order.find(params[:order_id])
  end
end
