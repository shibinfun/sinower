class ChannelsController < ApplicationController
  def index
    @kind = params[:kind]
    @categories = Category.where(parent_id: nil, category_kind: @kind).includes(children: { children: :children })
    
    if params[:category_id].present?
      @current_category = Category.includes(parent: { parent: :parent }).find_by(slug: params[:category_id]) || Category.find(params[:category_id])
      
      # SEO 优化: 如果是用 ID 访问的，或者 Slug 不匹配，301 重定向到 Slug URL
      if @current_category.slug.present? && params[:category_id] != @current_category.slug
        redirect_to category_path(slug: @current_category.slug, kind: @kind), status: :moved_permanently
        return
      end

      # Security check
      redirect_to root_path if @current_category.category_kind != @kind
      @skus = @current_category.all_descendant_skus.where(status: 'active').includes(:category, images_attachments: :blob).preload(:skuable).page(params[:page]).per(20)
    else
      @skus = Sku.joins(:category).where(categories: { category_kind: @kind }, status: 'active').includes(:category, images_attachments: :blob).preload(:skuable).order(position: :desc, created_at: :desc).page(params[:page]).per(20)
    end
    
    render "categories/index"
  end
end
