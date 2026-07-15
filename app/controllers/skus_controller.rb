class SkusController < ApplicationController
  def show
    @sku = Sku.find_by(slug: params[:slug]) || Sku.find(params[:slug])
    
    # SEO 重定向: 如果是用 ID 访问的，重定向到 slug 链接
    if params[:slug] == @sku.id.to_s && @sku.slug.present?
      redirect_to sku_path(slug: @sku), status: :moved_permanently
      return
    end

    @kind = @sku.category.category_kind
  end
end
