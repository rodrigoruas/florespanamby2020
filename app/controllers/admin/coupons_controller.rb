class Admin::CouponsController < ApplicationController

  def index
    @coupons = Coupon.all
  end

  def new
    @coupon = Coupon.new
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def create
    @coupon = Coupon.new
    @coupon = Coupon.create(coupon_params)
    if @coupon.save
      respond_to do |format|
        format.html { redirect_to admin_coupons_path }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      render :new
    end
  end

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
