class SpecialPaymentsController < ApplicationController
  before_action :set_special_order
  skip_before_action :authenticate_user!

  def new
    @special_order = SpecialOrder.find(params[:id])
  end

  def create
  customer = Stripe::Customer.create(
    source: params[:stripeToken],
    email:  params[:stripeEmail]
  )

  charge = Stripe::Charge.create(
    customer:     customer.id,   # You should store this customer id and re-use it.
    amount:       @special_order.price_cents,
    description:  "Pagamento Flor E Tal",
    currency:     @special_order.price.currency
  )

  @special_order.update(payment: charge.to_json, state: 'paid')
  redirect_to special_order_path(@special_order)

rescue Stripe::CardError => e
  flash[:alert] = e.message
  redirect_to redirect_to order_path(@special_order)
end

private

  def set_special_order
    @special_order = SpecialOrder.find(params[:special_order_id])
  end
end
