class OrdersController < ApplicationController
  # before_action :authenticate_user!
  skip_before_action :authenticate_user!
  protect_from_forgery with: :null_session, only: :update_price
  skip_before_action :verify_authenticity_token, only: :update_price
  def index
    @orders = Order.where(user: current_user)
    if params[:transaction_id].present?
      @order = @orders.last
      @order.transaction_id = params[:transaction_id]
      @order.payment_hash = payment_json(@order.transaction_id)
      @order.state = "paid"
      @order.save
    end
  end

  def new
    @order_details = OrderDetail.where(user: current_user)
    @order = Order.new
  end

  def show
    @coupons = Coupon.all
    @products = Product.filter_max_price(50).sample(3)
    @order = Order.find(params[:id])
    redirect_to root_path unless check_owner
    if @order.admin_order 
      @delivery_costs = @delivery_costs.where(published: true)
    elsif @order.delivery_date == Date.parse("16/05/2020")
      @delivery_costs = []
      @message = "Essa data não está mais disponível para entrega"
    else 
      @delivery_costs = DeliveryCost.display_delivery_costs(@order.delivery_date, @order.delivery_distance)
      @delivery_costs = @delivery_costs.where(published: true)
    end  
    if params[:code].present?
      if check_coupon_code(params[:code])
        redirect_to order_path(@order)
      else
        render :show
      end
    end
  end

  def create
    @order = Order.new
    @order_details = OrderDetail.where(user: get_user).where('created_at >= ?', 15.minutes.ago)
    @order = Order.new(order_params)
    set_date
    if @order.zipcode == "" || @order.street == "" || @order.street_number == ""
      flash[:alert] = "Todos os campos com * são obrigatórios"
      render "order_details/index"
    elsif  BlockedDate.where(date: @order.delivery_date).count > 0
      flash[:alert] = "Data Indisponível"
        redirect_to order_details_path  
    elsif params["order"]["delivery_date"] == ""
        flash[:alert] = "Preencha a data de entrega para continuar"
        redirect_to order_details_path  
    else
      set_order_params
      set_order_price
      set_coordinates unless @order.latitude
      @order.order_details = @order_details
      if @order.delivery_distance > 25
        flash[:alert] = "Não entregamos na sua localidade."
      end
      @order.address = [@order.street, @order.street_number, @order.complement, @order.neighborhood, @order.city].compact.join(', ')
      if @order.save
        respond_to do |format|
          format.html { redirect_to order_path(@order) }
          format.js
        end
      else
        render "order_details/index"
      end
    end
  end

  def set_coordinates
    coordinates = GoogleGeocoding.new(@address_to_geocode).get_coordinates
    @order.latitude = coordinates["lat"]
    @order.longitude = coordinates["lng"]
  end

  def set_date
    date = params["order"]["delivery_date"].gsub(" ","")
    @order.delivery_date = Date.strptime(date,'%d/%m/%Y')
  end

  def update
    @order = Order.find(params[:id])
    @order.delivery_cost = DeliveryCost.find(params[:order][:delivery_cost_id])
    @order.sender_phone = params[:order][:sender_phone]
    @order.sender_name = params[:order][:sender_name]
    @order.state = "payment"
    if @order.update(order_params)
      respond_to do |format|
        if @order.admin_order
          format.html { redirect_to admin_orders_path }
        else
          format.html { redirect_to new_order_payment_path(@order) }
        end
      end
    else
      respond_to do |format|

        format.js  # <-- idem
      end
    end
  end

  # def create_stripe_session
  #   line_items = []
  #   @order.order_details.each do |od|
  #     line_items << {
  #       name: od.product.name,
  #       amount: od.product.price_cents,
  #       currency: 'brl',
  #       quantity: od.quantity
  #     }
  #   end

  #   line_items << {
  #     name: "Frete",
  #     amount: @order.delivery_cost.price,
  #     currency: 'brl',
  #     quantity: 1
  #   }
  # session = Stripe::Checkout::Session.create(
  #   payment_method_types: ['card'],
  #   line_items: line_items,
  #   success_url: order_url(@order),
  #   cancel_url: new_order_payment_url(@order)
  # )
  #   @order.checkout_session_id =  session.id
  # end

  def update_price
    @order = Order.find(params[:order_id])
    @order.delivery_cost = DeliveryCost.find(params[:order][:delivery_cost_id])
    @order.delivery_price = @order.delivery_cost.get_price(@order.delivery_distance)
    @order.price = @order.get_products_price + @order.delivery_price
    @order.save(:validate => false)
    respond_to do |format|
      format.js
    end
  end

  def update_price_coupon
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      redirect_to order_path
    else
      redirect_to order_path
    end
  end

  def set_order_params
    @order.order_sku = "Compra de Produtos"
    @order.state = "pending"
    @order.user = get_user
    set_order_price
    set_delivery_distance
  end

  def set_delivery_distance
    @order.country = "Brasil"
    @address_to_geocode = [@order.street, @order.street_number, @order.neighborhood, @order.city].compact.join(', ')
    @address_to_geocode.gsub!("s/n", "") if  @address_to_geocode.include? "s/n"
    @order.delivery_distance = GoogleGeocoding.new(@address_to_geocode).get_distance
  end

  def set_order_price
    price = 0
    @order_details.each do |od|
      price =  price + od.price * od.quantity
    end
    @order.price = price
  end

  def check_coupon_code(coupon_code)
    available_coupons = @coupons.where(code: coupon_code)
    return false if available_coupons.blank?
    available_coupons.each do |coupon|
      if coupon.valid?
        @order.coupon = coupon
        @order.price = @order.price * (1 - coupon.discount_percentage.to_f / 100)
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

  def order_params
    params.require(:order).permit(
        :price, :guest_email, :address, :user_id, :delivery_date, :request,
        :sender_name, :sender_phone, :guest_email, :admin_order, :neighborhood,
        :message, :payment,:order_sku, :state, :zipcode, :delivery_price,
        :street, :street_number, :city, :uf,
        :country, :lat, :lng, :latitude, :longitude, :complement,
        :recipient_name, :recipient_phone, :transaction_id,
        :payment_hash, :delivery_distance, :checkout_session_id,
        :delivery_cost_id, :order_detail_ids => [])
  end
end

