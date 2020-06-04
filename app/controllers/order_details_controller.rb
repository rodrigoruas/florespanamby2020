class OrderDetailsController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    get_blocked_dates
    @delivery_costs = DeliveryCost.all
    @order_details = OrderDetail.where(user: get_user).where('created_at >= ?', 30.minutes.ago).order(created_at: :desc)
    @amount = 0
    @order_details.each do |od|
      @amount =  @amount + od.price * od.quantity
    end
    @order = Order.new
  end

  def create
    @order_detail = OrderDetail.new(order_detail_params)
    @order_detail.price = @order_detail.product.price
    @order_detail.user = get_user
    @order_detail.quantity = 1
    if @order_detail.save
      redirect_to order_details_path
    else
      redirect_back fallback_location: root_path
    end
  end

  def update
    @order_detail = OrderDetail.find(params[:id])
    if @order_detail.update(order_detail_params)
      respond_to do |format|
        format.html { redirect_to order_details_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'orders_details' }
        format.js  # <-- idem
      end
    end
  end

  def destroy
    @order_detail = OrderDetail.find(params[:id])
    if @order_detail.destroy
      redirect_to order_details_path
    else
      redirect_to order_details_path
    end
  end

  private

  def get_blocked_dates
    @blocked_dates =  []
    BlockedDate.all.each do |d|
      @blocked_dates << d.date.strftime("%Y-%m-%d")
    end
  end

  def order_detail_params
    params.require(:order_detail).permit(:product_id, :price, :quantity, :order_id, :user_id, :special_order_id)
  end

end
