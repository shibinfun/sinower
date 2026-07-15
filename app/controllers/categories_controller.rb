class CategoriesController < ApplicationController
  def index
    @kind = params[:kind]
    
    # 安全检查: 只允许 a, b, c 这三个频道，防止 Dangerous Send 漏洞
    unless @kind.nil? || %w[a b c].include?(@kind)
      redirect_to categories_path, alert: "无效的分类频道"
      return
    end

    @categories = Category.visible.where(parent_id: nil).includes(children: { children: :children })
    
    if @kind.present?
      @categories = @categories.where(category_kind: @kind)
    end
    
    if params[:category_id].present?
      begin
        # 兼容 slug 和 ID
        @current_category = Category.visible.includes(parent: { parent: :parent }).find_by(slug: params[:category_id]) || Category.visible.find(params[:category_id])
        
        # SEO 优化: 如果是用 ID 访问的，或者 Slug 不匹配，301 重定向到 Slug URL
        if @current_category.slug.present? && params[:category_id] != @current_category.slug
          redirect_to category_path(slug: @current_category.slug, kind: @kind), status: :moved_permanently
          return
        end

        @skus = @current_category.all_descendant_skus.where(status: 'active').includes(:category, images_attachments: :blob).preload(:skuable).page(params[:page]).per(20)
      rescue ActiveRecord::RecordNotFound
        redirect_to categories_path, alert: "未找到指定的分类"
        return
      end
    else
      if @kind.present?
        @skus = Sku.joins(:category).where(categories: { category_kind: @kind, hidden: false }, status: 'active').includes(:category, images_attachments: :blob).preload(:skuable).order(position: :desc, created_at: :desc).page(params[:page]).per(20)
      else
        @skus = Sku.joins(:category).where(categories: { hidden: false }, status: 'active').includes(:category, images_attachments: :blob).preload(:skuable).order(position: :desc, created_at: :desc).page(params[:page]).per(20)
      end
    end
  end

  def show
    @category = Category.find_by(slug: params[:slug]) || Category.find(params[:slug])
    
    # 如果是用 ID 访问的，301 重定向到 slug 链接
    if @category.slug.present? && params[:slug] != @category.slug
      redirect_to category_path(slug: @category.slug), status: :moved_permanently
      return
    end

    @kind = @category.category_kind
    @categories = Category.visible.where(parent_id: nil, category_kind: @kind).includes(children: { children: :children })
    @current_category = @category
    @skus = @current_category.all_descendant_skus.where(status: 'active').includes(:category, images_attachments: :blob).preload(:skuable).page(params[:page]).per(20)
    
    render :index
  end
end
