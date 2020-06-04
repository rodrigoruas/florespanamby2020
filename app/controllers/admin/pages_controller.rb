class Admin::PagesController < ApplicationController
  before_action :check_admin!
  def dashboard
    @special_order = SpecialOrder.new
  end

  def check_admin!
    unless current_user.admin
      redirect_to root_path
    end
  end

  def mothers_map
    date = Date.today
    @orders = Order.where("delivery_date = ? and state = ?", date, "paid")
    @orders =  @orders.sort_by{|ord| ord.global_id}.reverse  
    @markers = []
    @orders.each do |order|
      @markers << {
        lat: order.latitude,
        lng:  order.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: {order: order})
        }
    end
  end
end
