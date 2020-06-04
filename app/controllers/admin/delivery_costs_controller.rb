class Admin::DeliveryCostsController < ApplicationController
  before_action :authenticate_user!
  def index
    @delivery_costs = DeliveryCost.where(published: true)
  end

  def new
    @delivery_cost = DeliveryCost.new
  end

  def create
    @delivery_cost = DeliveryCost.new(delivery_cost_params)
    if @delivery_cost.save
      redirect_to admin_delivery_costs_path
    else
      render 'new'
    end
  end

  def edit
    @delivery_cost = DeliveryCost.find(params[:id])
  end

  def update
    @delivery_cost = DeliveryCost.find(params[:id])
    if @delivery_cost.update(delivery_cost_params)
      respond_to do |format|
        format.html { redirect_to admin_delivery_costs_path }
      end
    else
      respond_to do |format|
        format.html { render 'edit' }
        format.js  # <-- idem
      end
    end
  end

  def destroy
    @delivery_cost = DeliveryCost.find(params[:id])
    if @delivery_cost.destroy
      redirect_to admin_delivery_costs_path
    else
      render 'index'
    end
  end

  private

  def delivery_cost_params
    params.require(:delivery_cost).permit(:name, :max_distance, :min_distance, :price, :weekend, :exception, :published, :mother, :multiplier)
  end

end
