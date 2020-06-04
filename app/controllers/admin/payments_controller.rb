class Admin::PaymentsController < ApplicationController
  before_action :set_order

  def new
    @order = Order.find(params[:order_id])
  end

  def create
  customer = Stripe::Customer.create(
    source: params[:stripeToken],
    email:  params[:stripeEmail]
  )

  charge = Stripe::Charge.create(
    customer:     customer.id,   # You should store this customer id and re-use it.
    amount:       @order.price_cents,
    description:  "Pagamento Flor E Tal",
    currency:     @order.price.currency
  )

  @order.update(payment: charge.to_json, state: 'paid')
  redirect_to order_path(@order)

rescue Stripe::CardError => e
  flash[:alert] = e.message
  redirect_to redirect_to order_path(@order)
end

private

  def set_order
    @order = current_user.orders.where(state: 'pending').find(params[:order_id])
  end
end
