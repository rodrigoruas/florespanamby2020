 class Admin::SpecialOrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:update_special]
  def new
    @special_order = SpecialOrder.new
  end

  def show
    @order_detail = OrderDetail.new
    @special_order = SpecialOrder.find(params[:id])
    @order_details = @special_order.order_details
    @order = Order.new
    @amount = 0
    @order_details.each do |od|
      @amount =  @amount + od.price * od.quantity
    end
 
    if params[:search].present?
      @products = Product.search_by_name(params[:search])
      respond_to do |format|
        format.js
      end
    else
      @products = Product.all
    end 
  end

  def create
    @special_order = SpecialOrder.new
    if @special_order.save
      respond_to do |format|
        format.html { redirect_to admin_special_order_path(@special_order) }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      redirect_back fallback_location: root_path
    end
  end

  def update_special
    @order_detail = OrderDetail.find(params[:order_details_id])
    action = params[:quantity]
    if action == "up"
      @order_detail.quantity += 1
    elsif action == "down"
      @order_detail.quantity -= 1 
    end
    if @order_detail.save
      respond_to do |format|
        # format.html { redirect_to admin_special_order_path(@special_order) }
        format.js
      end
    else
      respond_to do |format|
        # format.html { redirect_to admin_special_order_path(@special_order) }
        format.js  # <-- idem
      end
    end
  end


  private

  # def order_params
  #   params.require(:special_order).permit()
  # end
end
