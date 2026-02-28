class ChannelsController < ApplicationController
  def index
    @kind = params[:kind]
    @categories = Category.where(parent_id: nil, category_kind: @kind).includes(:children)
    
    if params[:category_id].present?
      @current_category = Category.find(params[:category_id])
      # Security check
      redirect_to root_path if @current_category.category_kind != @kind
      @skus = @current_category.all_descendant_skus.where(visible: true).includes(:category).page(params[:page]).per(20)
    else
      @skus = Sku.joins(:category).where(categories: { category_kind: @kind }, visible: true).includes(:category).page(params[:page]).per(20)
    end
    
    render "categories/index"
  end
end
