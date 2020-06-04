class PaymentsController < ApplicationController
  # before_action :set_order
  skip_before_action :authenticate_user!
  def new
    @order = Order.find(params[:order_id])
    redirect_to root_path unless check_owner
    @coupons = Coupon.all
    @discount = @order.get_products_price - (@order.price - @order.delivery_price)
    if params[:code].present?
      if check_coupon_code(params[:code])
        @discount = @order.get_products_price - (@order.price - @order.delivery_price)
        redirect_to new_order_payment_path(@order)
      else
        flash[:alert] = "Código inválido"
        redirect_to new_order_payment_path(@order)
      end
    end
  end

  def create
    @order = Order.find(params[:order_id])
      itens_array = []
      @order.order_details.each do |od|
        itens_array << {
            id: od.product.id.to_s,
            title: od.product.name,
            unit_price: od.price_cents,
            quantity: od.quantity,
            tangible: true
          }
      end
      PagarMe.api_key = Rails.configuration.pagarme[:api_key]

      transaction  = PagarMe::Transaction.new({
        amount: @order.price_cents,
        payment_method: "credit_card",
        card_number: params[:card_number],
        card_holder_name: params[:card_holder_name],
        card_expiration_date: params[:card_expiration_date].tr('^0-9', ''),
        card_cvv: params[:card_ccv],
        postback_url: "https://localhost:3000/",
        installments: params[:installments],
        customer: {
          external_id: get_user.id.to_s,
          name: params[:card_holder_name],
          type: "individual",
          country: "br",
          email: @order.guest_email,
          documents: [
            {
              type: "cpf",
              number: params[:cpf].tr('^0-9', '')

            }

          ],
          phone_numbers: ["+55" + @order.sender_phone.tr('^0-9', '')],
        },
        billing: {
          name: params[:card_holder_name],
          address: {
            country: "br",
            state: params[:card_holder_uf],
            city: params[:card_holder_city],
            neighborhood: params[:card_holder_neighborhood],
            street: params[:card_holder_street],
            street_number: params[:card_holder_street_number],
            zipcode: params[:card_holder_zipcode].tr('^0-9', '')
          }
        },

        items: itens_array
      })
      begin
        response_result = transaction.charge
      rescue
        flash[:alert] = 'Pagamento Não Autorizado'
        render :new
        # redirect_to new_order_payment_path(@order)
        return
      end  
      while transaction["status"] == "processing" do
        transaction = PagarMe::Transaction.find_by_id(response_result.id)
        puts transaction
        puts "waiting"
      end
      response_events = transaction.events
      response_events_parsed = JSON.parse(response_events.to_json)
      response_result_parsed = JSON.parse(response_result.to_json)
      if payment_sucess?(transaction)
        last_global_id = Order.where(["state = ? or state = ? or state = ? ", "paid", "delivered", "shipping"]).ordered_by_global_id.first.global_id
        global_id = last_global_id + 1
        if @order.update(payment: response_result_parsed, 
                          payment_events: response_events_parsed, 
                          state: 'paid',
                          global_id: global_id)   
          if Rails.env.production?   
            begin                      
              @order.send_confirmation_mail
              @order.send_sms
            rescue => e
            end  
          end  
          redirect_to order_path(@order)
        else
          flash[:alert] = 'Pagamento Não Autorizado'
          redirect_to new_order_payment_path(@order)
        end
      else
        flash[:alert] = 'Pagamento Não Autorizado'
        redirect_to new_order_payment_path(@order)
      end 
  end
  def payment_sucess?(transaction)
    status = transaction["status"]
    if status =="paid"
      true
    else
      false
    end
  end

  def check_coupon_code(coupon_code)
    available_coupons = @coupons.where(code: coupon_code)
    return false if available_coupons.blank?
    available_coupons.each do |coupon|
      if coupon.valid?
        @order.coupon = coupon
        @order.price = (@order.get_products_price) * (1 - @order.coupon.discount_percentage.to_f / 100) + @order.delivery_price
        @order.save
        return true
      else
        return false
      end
    end
  end

  def check_owner
    if current_user
      return true if current_user.admin
    end
    if  @order.user.guest_id == session.id 
      true
    else
      false
    end
  end

  private

  def set_order
    @order = get_user.orders.where(state: 'pending').find(params[:order_id])
  end

   def payments_params
    params.require(:pa).permit(:keywords, :category_id, :min_price_cents, :max_price_cents)
  end
end
