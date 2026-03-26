class Admin::SkusController < Admin::BaseController
  before_action :set_sku, only: [:show, :edit, :update, :destroy]

  def index
    @category_kind = params[:kind] || 'a'
    @skus = Sku.joins(:category).where(categories: { category_kind: @category_kind }).includes(:category).all

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(Sku.all), filename: "skus-#{Date.today}.csv" }
    end
  end

  def export
    @skus = Sku.all.includes(:category, :skuable)
    send_data generate_csv(@skus), filename: "all-skus-#{Date.today}.csv"
  end

  def import_page
  end

  def import
    if params[:file].present?
      result = SkuImporter.import(params[:file])
      redirect_to admin_skus_path, notice: "导入完成：成功 #{result[:success]}，失败 #{result[:failed]}"
    else
      redirect_to import_page_admin_skus_path, alert: "请上传 CSV 文件。"
    end
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

  def generate_csv(skus)
    require 'csv'
    CSV.generate(headers: true) do |csv|
      # 定义表头
      base_headers = ["ID", "名称", "频道", "分类路径", "价格", "库存", "状态", "可见性", "图片URLs", "说明书URL", "规格书URL"]
      detail_headers = [
        "net_capacity", "unit_dimensions", "packaging_dimensions", "voltage_frequency", "temp_range", 
        "burners_and_control_method", "gas_type", "intake_tube_pressure", "per_btu", "total_btu", 
        "regulator", "work_area", "exterior_dimensions", "product_dimensions", "sink_bowl_dimensions", 
        "sink_depth", "leg_bracing", "faucet_and_drain", "standard_features_html", "standard_features_zh_html"
      ]
      csv << base_headers + detail_headers

      skus.each do |sku|
        category_path = sku.category.ancestors_and_self.map(&:name).join(" > ")
        image_urls = sku.images.map { |img| Rails.application.routes.url_helpers.url_for(img) if img.present? }.compact.join(",")
        manual_url = sku.manual.attached? ? Rails.application.routes.url_helpers.url_for(sku.manual) : ""
        spec_sheet_url = sku.spec_sheet.attached? ? Rails.application.routes.url_helpers.url_for(sku.spec_sheet) : ""
        
        row = [
          sku.id, sku.name, sku.category.category_kind, category_path, sku.price, sku.stock, sku.status, sku.visible, 
          image_urls, manual_url, spec_sheet_url
        ]
        
        # 详情字段
        detail = sku.skuable
        if detail
          detail_row = [
            detail.try(:net_capacity), detail.try(:unit_dimensions), detail.try(:packaging_dimensions), 
            detail.try(:voltage_frequency), detail.try(:temp_range), detail.try(:burners_and_control_method), 
            detail.try(:gas_type), detail.try(:intake_tube_pressure), detail.try(:per_btu), 
            detail.try(:total_btu), detail.try(:regulator), detail.try(:work_area), 
            detail.try(:exterior_dimensions), detail.try(:product_dimensions), 
            detail.try(:sink_bowl_dimensions), detail.try(:sink_depth), detail.try(:leg_bracing), 
            detail.try(:faucet_and_drain), detail.try(:standard_features).to_s, detail.try(:standard_features_zh).to_s
          ]
        else
          detail_row = Array.new(detail_headers.size, nil)
        end
        
        csv << row + detail_row
      end
    end
  end

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
