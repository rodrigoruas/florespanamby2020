class Admin::BlockedDatesController < ApplicationController
  
  def index
    @blocked_dates = BlockedDate.all
  end

  def new
    @blocked_date = BlockedDate.new
  end

  def create
    @blocked_date = BlockedDate.new
    @blocked_date.date = params[:date]
    if @blocked_date.save
      redirect_to admin_blocked_dates_path
    else
      render :new
    end
  end

  def destroy
    @blocked_date = BlockedDate.find(params[:id])
    @blocked_date.destroy
    redirect_to admin_blocked_dates_path
  end


  private

end
