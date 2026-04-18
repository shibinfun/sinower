class Admin::SkusController < Admin::BaseController
  before_action :set_sku, only: [:show, :edit, :update, :destroy, :delete_image, :delete_manual, :delete_spec_sheet]

  def index
    @q = params[:q]
    @category_id = params[:category_id]
    session[:sku_list_category_id] = @category_id

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


  def update_positions
    unless params[:positions].present?
      return redirect_back fallback_location: admin_skus_path, alert: "未提供有效的排序数据。"
    end

    positions = params[:positions].to_unsafe_h
                                  .transform_keys { |k| Integer(k) rescue nil }
                                  .transform_values { |v| Integer(v) rescue nil }
                                  .reject { |k, v| k.nil? || v.nil? || v < 0 || v > 999_999 }

    positions.each do |sku_id, position|
      Sku.where(id: sku_id).update_all(position: position)
    end

    redirect_back fallback_location: admin_skus_path, notice: "排序权重已更新。"
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
      # 提取图片位置信息，并从 filtered_params 中删除，防止 UnknownAttributeError
      image_positions = filtered_params.delete(:image_positions)
      
      # 过滤空的图片/文件占位符，防止保存时出现空附件
      # 注意：不要过滤 position 字段，因为 0.blank? 是 true
      # 提取图片/文件参数，用于后续单独处理，避免 Sku.new(params) 可能引起的自动分配
      images = filtered_params.delete(:images)
      manual = filtered_params.delete(:manual)
      spec_sheet = filtered_params.delete(:spec_sheet)

      @sku = Sku.new(filtered_params)
      if @sku.save
        # 显式使用 attach 附加图片/文件
        @sku.images.attach(images) if images.present?
        @sku.manual.attach(manual) if manual.present?
        @sku.spec_sheet.attach(spec_sheet) if spec_sheet.present?

        update_image_positions(@sku, image_positions)
        redirect_to sku_list_path, notice: "SKU 创建成功。"
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
      # 提取图片位置信息，并从 filtered_params 中删除，防止 UnknownAttributeError
      image_positions = filtered_params.delete(:image_positions)

      # 如果用户在编辑时没有上传新文件，从 params 中剔除对应键，防止覆盖旧文件
      # 注意：不要过滤 position 字段，因为 0.blank? 是 true
      # 注意：对于 images，如果使用了 config.active_storage.replace_on_assign_to_many = false
      # 那么上传新图片会附加到旧图片。如果上传的是空数组，则不进行任何操作。
      # 提取图片/文件参数，用于后续单独处理，避免 update 方法的全量替换行为
      images = filtered_params.delete(:images)
      manual = filtered_params.delete(:manual)
      spec_sheet = filtered_params.delete(:spec_sheet)

      if @sku.update(filtered_params)
        # 显式使用 attach 附加图片，确保不替换旧图片
        @sku.images.attach(images) if images.present?
        @sku.manual.attach(manual) if manual.present?
        @sku.spec_sheet.attach(spec_sheet) if spec_sheet.present?

        update_image_positions(@sku, image_positions)
        redirect_to sku_list_path, notice: "SKU 更新成功。"
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
    redirect_to sku_list_path, notice: "SKU 已删除。"
  end

  def delete_image
    return redirect_to sku_list_path, alert: "SKU 未找到。" unless @sku
    
    image = @sku.images.find(params[:image_id])
    image.purge
    redirect_back fallback_location: edit_admin_sku_path(@sku), notice: "图片已删除。"
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: edit_admin_sku_path(@sku), alert: "图片未找到。"
  rescue ActiveStorage::InvariableError
    redirect_back fallback_location: edit_admin_sku_path(@sku), alert: "文件格式错误，无法处理。"
  end

  def delete_manual
    return redirect_to sku_list_path, alert: "SKU 未找到。" unless @sku
    @sku.manual.purge if @sku.manual.attached?
    redirect_back fallback_location: edit_admin_sku_path(@sku), notice: "技术手册已删除。"
  end

  def delete_spec_sheet
    return redirect_to sku_list_path, alert: "SKU 未找到。" unless @sku
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

        image_urls = sku.images.attached? ? sku.images.map { |img| url_for(img) }.join(",") : ""
        manual_url = sku.manual.attached? ? url_for(sku.manual) : ""
        spec_sheet_url = sku.spec_sheet.attached? ? url_for(sku.spec_sheet) : ""
        
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

  def sku_list_path
    category_id = session[:sku_list_category_id]
    category_id.present? ? admin_skus_path(category_id: category_id) : admin_skus_path
  end

  def update_image_positions(sku, image_positions)
    return unless image_positions.present?

    valid_ids = sku.images_attachments.pluck(:id)
    image_positions.each do |id, pos|
      parsed_id = Integer(id) rescue nil
      next unless parsed_id && valid_ids.include?(parsed_id)
      parsed_pos = (Integer(pos) rescue 0).clamp(0, 999_999)
      ActiveStorage::Attachment.where(id: parsed_id).update_all(position: parsed_pos)
    end
  end

  def set_sku
    @sku = Sku.find(params[:id])
  end

  def sku_params
    params.require(:sku).permit(
      :name, :category_id, :price, :stock, :status, :position, :manual, :spec_sheet, :skuable_type, images: [],
      image_positions: {},
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
