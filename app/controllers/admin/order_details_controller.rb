class Admin::OrderDetailsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
  end

  def new
    @products = Product.all
  end


  def create
    @order_detail = OrderDetail.new
    @order_detail.product = Product.find(params[:order_detail][:product_id])
    @order_detail.price = @order_detail.product.price
    @order_detail.user = get_user
    @order_detail.special_order_id = params[:special_order_id]
    @order_detail.quantity = 1
    @special_order = SpecialOrder.find(params[:special_order_id])
    if @order_detail.save
      redirect_to admin_special_order_path(@special_order)
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
        format.js 
      end
    end
  end

  def destroy
    @special_order = SpecialOrder.find(params[:special_order_id])
    @order_detail = OrderDetail.find(params[:id])
    if @order_detail.destroy
      redirect_to admin_special_order_path(@special_order)
    else
      redirect_to admin_special_order_path(@special_order)
    end
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:product_id, :price, :quantity, :order_id, :user_id, :special_order)
  end

end
