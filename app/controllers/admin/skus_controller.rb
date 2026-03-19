class Admin::SkusController < Admin::BaseController
  before_action :set_sku, only: [:show, :edit, :update, :destroy]

  def index
    @category_kind = params[:kind] || 'a'
    @skus = Sku.joins(:category).where(categories: { category_kind: @category_kind }).includes(:category).all
  end

  def show
  end

  def new
    category_id = params[:category_id]
    category = Category.find_by(id: category_id) if category_id.present?
    
    @sku = Sku.new(category: category)
    
    if category && category.leaf?
      case category.category_kind
      when "a"
        @sku.skuable = ASkuDetail.new
      when "b"
        @sku.skuable = BSkuDetail.new
      when "c"
        @sku.skuable = CSkuDetail.new
      else
        @sku.skuable = nil
      end
    else
      @sku.skuable = nil
    end
  end

  def edit
    if @sku.category && @sku.category.leaf? && @sku.skuable.nil?
      case @sku.category.category_kind
      when "a"
        @sku.skuable = ASkuDetail.new
      when "b"
        @sku.skuable = BSkuDetail.new
      when "c"
        @sku.skuable = CSkuDetail.new
      end
    end
  end

  def create
    @sku = Sku.new(sku_params)
    if @sku.save
      redirect_to admin_skus_path, notice: "SKU 创建成功。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @sku.update(sku_params)
      redirect_to admin_skus_path, notice: "SKU 更新成功。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sku.destroy
    redirect_to admin_skus_path, notice: "SKU 已删除。"
  end

  def delete_image
    image = @sku.images.find(params[:image_id])
    image.purge
    redirect_back fallback_location: edit_admin_sku_path(@sku), notice: "图片已删除。"
  end

  private

  def set_sku
    @sku = Sku.find(params[:id])
  end

  def sku_params
    params.require(:sku).permit(
      :name, :category_id, :price, :stock, :status, :visible, :manual, :spec_sheet, :skuable_type, images: [],
      skuable_attributes: [
        :id, :net_capacity, :unit_dimensions, :packaging_dimensions,
        :voltage_frequency, :temp_range, :standard_features, :standard_features_zh,
        :burners_and_control_method, :gas_type, :intake_tube_pressure,
        :per_btu, :total_btu, :regulator, :work_area,
        :exterior_dimensions, :standard_features_zh,
        :product_dimensions, :sink_bowl_dimensions, :sink_depth, :leg_bracing, :faucet_and_drain
      ]
    )
  end
end
