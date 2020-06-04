class Admin::CategoriesController < ApplicationController

  def index
    @categories = Category.all.sort_by{|category| category.navbar_order}
    @sub_categories = SubCategory.all
    @sub_category = SubCategory.new
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path
    else
      render 'new'
    end
  end

  def show
    @category = Category.find_by(slug: params[:slug])
  end

  def edit
    @category = Category.find_by(slug: params[:slug])
  end

  def update
    @category = Category.find_by(slug: params[:slug])
    if @category.update(category_params)
      respond_to do |format|
        format.html { redirect_to admin_categories_path }
      end
    else
      respond_to do |format|
        format.html { render 'edit' }
        format.js  # <-- idem
      end
    end
  end

  def destroy
    @category = Category.find_by(slug: params[:slug])
    if @category.destroy
      redirect_to admin_categories_path
    else
      render 'index'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :navbar, :slug, :navbar_order)
  end
end
