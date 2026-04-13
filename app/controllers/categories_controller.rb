class CategoriesController < ApplicationController
  def index
    @kind = params[:kind]
    
    # 安全检查: 只允许 a, b, c 这三个频道，防止 Dangerous Send 漏洞
    unless @kind.nil? || %w[a b c].include?(@kind)
      redirect_to categories_path, alert: "无效的分类频道"
      return
    end

    @categories = Category.where(parent_id: nil).includes(children: { children: :children })
    
    if @kind.present?
      @categories = @categories.where(category_kind: @kind)
    end
    
    if params[:category_id].present?
      @current_category = Category.includes(parent: { parent: :parent }).find(params[:category_id])
      @skus = @current_category.all_descendant_skus.where(status: 'active').includes(:category, images_attachments: :blob).preload(:skuable).page(params[:page]).per(20)
    else
      if @kind.present?
        @skus = Sku.joins(:category).where(categories: { category_kind: @kind }, status: 'active').includes(:category, images_attachments: :blob).preload(:skuable).order(position: :desc, created_at: :desc).page(params[:page]).per(20)
      else
        @skus = Sku.where(status: 'active').includes(:category, images_attachments: :blob).preload(:skuable).order(position: :desc, created_at: :desc).page(params[:page]).per(20)
      end
    end
  end

  def show
    @category = Category.find(params[:id])
    redirect_to categories_path(category_id: @category.id)
  end
end
