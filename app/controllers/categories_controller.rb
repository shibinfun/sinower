class CategoriesController < ApplicationController
  def index
    @kind = params[:kind]
    @categories = Category.where(parent_id: nil).includes(children: :children)
    
    if @kind.present?
      @categories = @categories.where(category_kind: @kind)
    end
    
    if params[:category_id].present?
      @current_category = Category.find(params[:category_id])
      @skus = @current_category.all_descendant_skus.where(status: 'active').includes(:category, images_attachments: :blob).page(params[:page]).per(20)
    else
      if @kind.present?
        @skus = Sku.joins(:category).where(categories: { category_kind: @kind }, status: 'active').includes(:category, images_attachments: :blob).order(position: :desc, created_at: :desc).page(params[:page]).per(20)
      else
        @skus = Sku.where(status: 'active').includes(:category, images_attachments: :blob).order(position: :desc, created_at: :desc).page(params[:page]).per(20)
      end
    end
  end

  def show
    @category = Category.find(params[:id])
    redirect_to categories_path(category_id: @category.id)
  end
end
