class Admin::SkusController < Admin::BaseController
  before_action :set_sku, only: [:show, :edit, :update, :destroy]

  def index
    @skus = Sku.includes(:category).all
  end

  def show
  end

  def new
    category = Category.find_by(id: params[:category_id])
    @sku = Sku.new(category: category)
    if category
      case category.category_kind
      when "a"
        @sku.skuable = ASkuDetail.new
      when "b"
        @sku.skuable = BSkuDetail.new
      when "c"
        @sku.skuable = CSkuDetail.new
      else
        # Fallback or handle 'd' if it's introduced later
        @sku.skuable = nil
      end
    else
      # Ensure @sku.skuable is initialized to a default or nil
      @sku.skuable = nil
    end
  end

  def edit
    if @sku.category && @sku.skuable.nil?
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

  private

  def set_sku
    @sku = Sku.find(params[:id])
  end

  def sku_params
    params.require(:sku).permit(
      :name, :category_id, :price, :stock, :status, :visible, :image,
      skuable_attributes: [
        :id, :net_capacity, :unit_dimensions, :packaging_dimensions,
        :voltage_frequency, :temp_range, :standard_features,
        :burners_and_control_method, :gas_type, :intake_tube_pressure,
        :per_btu, :total_btu, :regulator, :work_area,
        :exterior_dimensions, :key_features
      ]
    )
  end
end
