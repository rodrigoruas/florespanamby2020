class Admin::ProductsController < ApplicationController
  before_action :check_admin!

  def new
    @product = Product.new
    # @product_attachment = @product.product_attachments.build
    @sub_categories = SubCategory.all
  end

  def index
    if params[:query] == "published"
      @products = Product.where(published: true).ordered_by_name
    else
      @products = Product.ordered_by_name
    end
  end

  def list
    @products = Product.ordered_by_name

    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def create
    @sub_categories = SubCategory.all
    @product = Product.new(product_params)
    if @product.save
      unless params[:product_attachments].nil?
        params[:product_attachments]['photo'].each do |a|
          @product_attachment = @product.product_attachments.create!(:photo => a)
        end
      end
      redirect_to admin_products_path
    else
      render 'new'
    end
  end

  def edit
    @sub_categories = SubCategory.all
    @product = Product.find_by(slug: params[:slug])
    @sub_categories = SubCategory.all
  end

  def update
    @sub_categories = SubCategory.all
    @product = Product.find_by(slug: params[:slug])
    unless params[:product_attachments].nil?
      if @product.product_attachments.length > 0
        params[:product_attachments]['photo'].each do |a|
          @product_attachment = @product.product_attachments.update(:photo => a)
        end
      else
        params[:product_attachments]['photo'].each do |a|
          @product_attachment = @product.product_attachments.create!(:photo => a)
        end
      end
    end
    if @product.update(product_params)
      respond_to do |format|
        format.html { redirect_to admin_products_path }
      end
    else
      respond_to do |format|
        format.html { render 'edit' }
        format.js  # <-- idem
      end
    end
  end

  def destroy
    @product = Product.find_by(slug: params[:slug])
    if @product.destroy
      redirect_to admin_products_path
    else
      render 'index'
    end
  end

  private

  def check_admin!
    unless current_user.admin
      redirect_to root_path
    end
  end

  def product_params
    params.require(:product).permit(
      :name, :short_description, :description, :fake_price,
      :same_day_delivery, :published,
      :photo, :photo_cache, :price, :width, :height, :depth, :slug,
      :sub_category_ids => [],
      :product_attachments_attributes => [:id, :product_id, :photo])
  end

end
