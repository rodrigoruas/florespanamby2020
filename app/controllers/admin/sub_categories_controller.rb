class Admin::SubCategoriesController < ApplicationController

  def new
    @sub_category = SubCategory.new
    @category = Category.find_by(slug: params[:category_slug])
  end

  def edit
    @category = Category.find(params[:category_slug])
    @sub_category = SubCategory.find_by(slug: params[:slug])
  end

  def create
    @category = Category.find_by(slug: params[:category_slug])
    @sub_category = SubCategory.new(sub_category_params)
    @sub_category.category_id = @category.id
    @sub_category.param_name = I18n.transliterate(@sub_category.name).downcase.gsub(/\s+/, "")
    if @sub_category.save
      redirect_to admin_category_path(@category)
    else
      render 'new'
    end
  end

  def update
    @sub_category = SubCategory.find_by(slug: params[:slug])
    if @sub_category.update(sub_category_params)
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
    @sub_category = SubCategory.find_by(slug: params[:slug])
    if @sub_category.destroy
      redirect_to admin_categories_path
    else
      render 'index'
    end
  end


  private

  def sub_category_params
    params.require(:sub_category).permit(:name, :category_id, :param_name)
  end
end
