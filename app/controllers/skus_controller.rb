class SkusController < ApplicationController
  def show
    @sku = Sku.preload(:skuable).find(params[:id])
    @kind = @sku.category.category_kind
  end
end
