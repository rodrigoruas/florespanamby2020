class CouponsController < ApplicationController

  def update
    @coupon = Coupon.find(params[:id])
    if @coupon.update(coupon_params)
      respond_to do |format|
        format.html { redirect_to admin_orders_path }
      end
    else
      render :new
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(
        :code, :discount_percentage, :valid_until, :order_id)
  end
end
