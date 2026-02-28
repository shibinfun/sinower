class SkusController < ApplicationController
  def show
    @sku = Sku.find(params[:id])
    @kind = @sku.category.category_kind
  end
end
