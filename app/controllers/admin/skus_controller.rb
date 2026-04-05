class Admin::SkusController < Admin::BaseController
  before_action :set_sku, only: [:show, :edit, :update, :destroy, :delete_image, :delete_manual, :delete_spec_sheet]

  def index
    @q = params[:q]
    @category_id = params[:category_id]

    @skus = Sku.all.preload(:skuable).includes(category: :parent, images_attachments: :blob).order(position: :desc, created_at: :desc)

    if @q.present?
      @skus = @skus.where("LOWER(name) LIKE ?", "%#{@q.downcase}%")
    end

    if @category_id.present?
      @skus = @skus.where(category_id: @category_id)
    end

    @categories = Category.where(id: Category.joins(:skus).distinct.pluck(:id)).order(:name)

    respond_to do |format|
      format.html
      format.csv do
        @export_skus = @skus
        send_data generate_csv(@export_skus), filename: "skus-#{Date.today}.csv"
      end
    end
  end

  def export
    @skus = Sku.preload(:skuable).includes(category: :parent, images_attachments: :blob, manual_attachment: :blob, spec_sheet_attachment: :blob).order(position: :desc, created_at: :desc)
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

  def update_positions
    if params[:positions].present?
      params[:positions].each do |sku_id, position|
        Sku.find(sku_id).update(position: position)
      end
      redirect_back fallback_location: admin_skus_path, notice: "排序权重已更新。"
    else
      redirect_back fallback_location: admin_skus_path, alert: "未提供有效的排序数据。"
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
    begin
      filtered_params = sku_params
      # 过滤空的图片/文件占位符，防止保存时出现空附件
      # 注意：不要过滤 position 字段，因为 0.blank? 是 true
      [:images, :manual, :spec_sheet].each do |key|
        if filtered_params[key].is_a?(Array)
          filtered_params.delete(key) if filtered_params[key].all?(&:blank?)
        else
          filtered_params.delete(key) if filtered_params[key].blank?
        end
      end

      @sku = Sku.new(filtered_params)
      if @sku.save
        redirect_to admin_skus_path, notice: "SKU 创建成功。"
      else
        Rails.logger.error "SKU Create Failed: #{@sku.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error "SKU Create Exception: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      @sku.errors.add(:base, "保存出错: #{e.message}. 请检查图片或存储配置。")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    begin
      filtered_params = sku_params
      # 如果用户在编辑时没有上传新文件，从 params 中剔除对应键，防止覆盖旧文件
      # 注意：不要过滤 position 字段，因为 0.blank? 是 true
      [:images, :manual, :spec_sheet].each do |key|
        if filtered_params[key].is_a?(Array)
          filtered_params.delete(key) if filtered_params[key].all?(&:blank?)
        else
          filtered_params.delete(key) if filtered_params[key].blank?
        end
      end

      if @sku.update(filtered_params)
        redirect_to admin_skus_path, notice: "SKU 更新成功。"
      else
        Rails.logger.error "SKU Update Failed: #{@sku.errors.full_messages.join(', ')}"
        render :edit, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.error "SKU Update Exception: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      @sku.errors.add(:base, "更新出错: #{e.message}. 请检查图片或存储配置。")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sku.destroy
    redirect_to admin_skus_path, notice: "SKU 已删除。"
  end

  def delete_image
    return redirect_to admin_skus_path, alert: "SKU 未找到。" unless @sku
    
    image = @sku.images.find(params[:image_id])
    image.purge
    redirect_back fallback_location: edit_admin_sku_path(@sku), notice: "图片已删除。"
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: edit_admin_sku_path(@sku), alert: "图片未找到。"
  rescue ActiveStorage::InvariableError
    redirect_back fallback_location: edit_admin_sku_path(@sku), alert: "文件格式错误，无法处理。"
  end

  def delete_manual
    return redirect_to admin_skus_path, alert: "SKU 未找到。" unless @sku
    @sku.manual.purge if @sku.manual.attached?
    redirect_back fallback_location: edit_admin_sku_path(@sku), notice: "技术手册已删除。"
  end

  def delete_spec_sheet
    return redirect_to admin_skus_path, alert: "SKU 未找到。" unless @sku
    @sku.spec_sheet.purge if @sku.spec_sheet.attached?
    redirect_back fallback_location: edit_admin_sku_path(@sku), notice: "规格表已删除。"
  end

  private

  def generate_csv(skus)
    require 'csv'
    CSV.generate(headers: true) do |csv|
      # 定义表头
      base_headers = ["ID", "排序权重", "名称", "频道", "分类路径", "价格", "库存", "状态", "图片URLs", "说明书URL", "规格书URL"]
      detail_headers = [
        "net_capacity", "unit_dimensions", "packaging_dimensions", "voltage_frequency", "temp_range", 
        "burners_and_control_method", "gas_type", "intake_tube_pressure", "per_btu", "total_btu", 
        "regulator", "work_area", "exterior_dimensions", "product_dimensions", "sink_bowl_dimensions", 
        "sink_depth", "leg_bracing", "faucet_and_drain", "standard_features_html", "standard_features_zh_html"
      ]
      csv << base_headers + detail_headers

      # 一次性加载所有分类并按 ID 索引，减少循环内的数据库查询
      categories_cache = Category.all.includes(:parent).index_by(&:id)

      skus.each do |sku|
        # 使用缓存构建路径
        cat = categories_cache[sku.category_id]
        path_segments = []
        while cat
          path_segments.unshift(cat.name)
          cat = categories_cache[cat.parent_id]
        end
        category_path = path_segments.join(" > ")

        image_urls = sku.images.attached? ? sku.images.map { |img| Rails.application.routes.url_helpers.url_for(img) }.join(",") : ""
        manual_url = sku.manual.attached? ? Rails.application.routes.url_helpers.url_for(sku.manual) : ""
        spec_sheet_url = sku.spec_sheet.attached? ? Rails.application.routes.url_helpers.url_for(sku.spec_sheet) : ""
        
        row = [
          sku.id, sku.position, sku.name, sku.category.category_kind, category_path, sku.price, sku.stock, sku.status,
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
      :name, :category_id, :price, :stock, :status, :position, :manual, :spec_sheet, :skuable_type, images: [],
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
