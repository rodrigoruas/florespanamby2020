class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:update_price]
  def index
    @disable_footer = true
    @orders = Order.where(["state = ? or state = ? or state = ? or state = ? ", "paid", "delivered", "shipping", "received"])
    @love_day = Date.strptime("12/06/2020",'%d/%m/%Y')
    if params[:sort].present?
      @orders = @orders.ordered_by_global_id if params[:sort] == "code"
      @orders = @orders.ordered_by_name if params[:sort] == "name"
      @orders = @orders.ordered_by_date if params[:sort] == "date"
    elsif params[:filter] == "today"
      @orders = @orders.where(["delivery_date = ?", Date.today])
    elsif params[:filter] == "love"
      @orders = @orders.where(["delivery_date = ?", @love_day])  
    elsif params[:date].present?
      parsed_date = params[:date].gsub(" ","")
      @date = Date.strptime(parsed_date,'%d/%m/%Y')  
      @orders = @orders.where(["delivery_date = ?", @date])
    else
      @orders = @orders.ordered_by_global_id
    end  
    @products = Product.ordered_by_name
    @special_order = SpecialOrder.new
  end

  def new
  end

  def product_list
    @orders = Order.where(["state = ?", "paid"])
    @products = []
    @orders.each do |order|
      order.products.each do |prod|
        @products << prod
      end
    end
    @array = []
    @products = @products.each_with_object(Hash.new(0)) { |h1, h2| h2[h1[:id]] += 1 }
    @products.each do |key, value|
      @array << {
        product: Product.find(key),
        qty: value
      }
    end
  end

  def create
    special_order = SpecialOrder.find(params[:special_order_id])
    @order_details = special_order.order_details
    @order = Order.new(order_params)
    if @order.zipcode == "" || @order.street == "" || @order.street_number == ""
      flash[:alert] = "Todos os campos com * são obrigatórios"
      render "order_details/index"
    elsif params["order"]["delivery_date"] == ""
        flash[:alert] = "Preencha a data de entrega para continuar"
        redirect_to order_details_path  
    else
      set_order_params
      set_order_price
      set_date
      set_coordinates unless @order.latitude
      @order.order_details = @order_details
      if @order.delivery_distance > 25
        flash[:alert] = "Não entregamos na sua localidade."
      end
      @order.address = [@order.street, @order.street_number, @order.complement, @order.neighborhood, @order.city].compact.join(', ')
      if @order.save
        respond_to do |format|
          format.html { redirect_to edit_admin_order_path(@order) }
          format.js
        end
      else
        render "admin/special_orders/#{special_order.id}"
      end
    end
  end

  def set_date
    date = params["order"]["delivery_date"].gsub(" ","")
    @order.delivery_date = Date.strptime(date,'%d/%m/%Y')
  end

  def set_coordinates
    coordinates = GoogleGeocoding.new(@address_to_geocode).get_coordinates
    @order.latitude = coordinates["lat"]
    @order.longitude = coordinates["lng"]
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

  def not_paid_orders
    date = Date.today - 5
    @orders = Order.where("state = ? and created_at > ? ", "payment", 5.days.ago).ordered_by_created_date
  end

  def show
    @order = Order.find(params[:id])
  end

  def receipt
    @order = Order.find(params[:order_id])
  end

  def print
    @order = Order.find(params[:order_id])
  end

  def edit
    @order = Order.find(params[:id])
    @delivery_costs = DeliveryCost.where(published: true)
    unless @order.global_id
      last_global_id = Order.where(["state = ? or state = ? or state = ? ", "paid", "delivered", "shipping"]).ordered_by_global_id.first.global_id
      @global_id = last_global_id + 1
    else
      @global_id = @order.global_id
    end
  end

  def update
    @order = Order.find(params[:id])
    params[:order][:price].gsub!(",",".") if params[:order] && params[:order][:price]
    if params[:order]
      if params[:order][:state] == "Entregue"
        params[:order][:state] = "delivered"
        @order.state = "delivered"
      elsif params[:order][:state] == "Em trânsito"
        params[:order][:state] = "shipping"
        @order.state = "shipping"
        
      elsif params[:order][:state] == "Pago"
        params[:order][:state] = "paid"
        @order.state = "paid"  
      elsif params[:order][:state] == "Arquivado"
        params[:order][:state] = "achived"
        @order.state = "archived" 
      elsif params[:order][:state] == "Recebido"
        params[:order][:state] = "received"
        @order.state = "received"        
      end
    end
    if @order.update(order_params)
      if @order.state == "shipping"
        begin
          unless @order.guest_email == "contato@florespanamby.com.br" || @order.guest_email == nil
            @order.send_shipping_mail
          end  
        rescue
          p "Email Invalid"
        end
      end
      respond_to do |format|
        format.html { redirect_to admin_orders_path }
      end
    else
      respond_to do |format|
        format.html { render :show }
        format.js  # <-- idem
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      redirect_to admin_orders_path
    else
      redirect_to admin_orders_path
    end
  end

  def define_address
    @order.zipcode
  end

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

  def send_email
    @order = Order.find(params[:order_id])
    @order.email_to_user
    redirect_to admin_order_path(@order)
  end
  private

  def order_params
    params.require(:order).permit(
        :price, :guest_email, :address, :user_id, :delivery_date, :request,
        :sender_name, :sender_phone, :guest_email, :admin_order, :neighborhood,
        :message, :payment,:order_sku, :state, :zipcode, :extra_products, :global_id,
        :street, :street_number, :city, :uf,
        :country, :lat, :lng, :latitude, :longitude, :complement,
        :recipient_name, :recipient_phone, :transaction_id,
        :payment_hash, :delivery_distance,
        :delivery_cost_id, :order_detail_ids => [])
  end

end

