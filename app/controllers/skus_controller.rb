class SkusController < ApplicationController
  def show
    @sku = Sku.includes(category: { parent: { parent: :parent } }).preload(:skuable).find(params[:id])
    @kind = @sku.category.category_kind
  end
end
