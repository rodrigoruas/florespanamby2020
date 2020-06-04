class StripeCheckoutSessionService
  def call(event)
    order = Order.find_by(checkout_session_id: event.data.object.id)
    checkout = Stripe::Checkout::Session.retrieve(event.data.object.id)
    if checkout.customer
      order.update(state: 'paid')
    else
      order.update(state: 'refused')
    end
  end
end