require 'twilio-ruby'
class TwilioSender
  def initialize(order)
    @order = order
  end

  def send_admin
    account_sid = ENV["TWILIO_SID"]
    account_token = ENV["TWILIO_TOKEN"]
    summary = ""

    @order.order_details.each do |od|
      summary = summary + "#{od.quantity} x  #{od.product.name} / "
    end

    numbers = ["+351919627061", "+351913177322", "+5511998617050"]
    body = "COMPRA ONLINE. Entrega para #{@order.delivery_date.strftime("%d / %m / %Y")} - #{@order.delivery_cost.name} - Pedido: #{summary} - Endereço: #{@order.address}"      
    
    numbers.each do |number|
        @client = Twilio::REST::Client.new(account_sid, account_token)
        @client.messages.create(
        body: body,
        from: '+13472425975',
        to: number
      )
    end  
  end
end