class SkusController < ApplicationController
  def show
    @sku = Sku.find(params[:id])
    @sku.increment!(:views) unless current_user&.admin?
    @kind = @sku.category.category_kind
  end
end
