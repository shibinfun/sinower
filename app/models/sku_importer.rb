require 'csv'
require 'open-uri'

class SkuImporter
  def self.import(file)
    success = 0
    failed = 0
    
    CSV.foreach(file.path, headers: true) do |row|
      begin
        Sku.transaction do
          # 1. 查找或创建分类
          category = find_or_create_category(row["分类路径"], row["频道"])
          
          # 2. 查找或创建 SKU
          sku = Sku.find_or_initialize_by(name: row["名称"], category_id: category.id)
          sku.price = row["价格"]
          sku.stock = row["库存"]
          sku.status = row["状态"] || "draft"
          sku.visible = row["可见性"].to_s.downcase == "true"
          
          # 3. 设置 Skuable Type (如果新建)
          if sku.new_record?
            sku.skuable_type = "#{row["频道"].upcase}SkuDetail"
            case row["频道"]
            when 'a' then sku.skuable = ASkuDetail.new
            when 'b' then sku.skuable = BSkuDetail.new
            when 'c' then sku.skuable = CSkuDetail.new
            end
          end
          
          sku.save!
          
          # 4. 更新详情字段
          update_detail(sku.skuable, row)
          
          # 5. 处理图片 (如果提供了 URL 且尚未附加同名文件)
          attach_images(sku, row["图片URLs"])
          attach_file(sku, :manual, row["说明书URL"])
          attach_file(sku, :spec_sheet, row["规格书URL"])
          
          success += 1
        end
      rescue => e
        Rails.logger.error "SKU Import Error: #{e.message} for row: #{row.to_h}"
        failed += 1
      end
    end
    
    { success: success, failed: failed }
  end

  private

  def self.find_or_create_category(path, kind)
    return nil if path.blank?
    
    names = path.split(">").map(&:strip)
    parent = nil
    
    names.each do |name|
      category = Category.find_or_initialize_by(name: name, parent_id: parent&.id)
      if category.new_record?
        category.category_kind = kind
        category.name_zh = name # 默认同名，以后手动改
        category.save!
      end
      parent = category
    end
    parent
  end

  def self.update_detail(detail, row)
    return unless detail
    
    fields = [
      "net_capacity", "unit_dimensions", "packaging_dimensions", "voltage_frequency", "temp_range", 
      "burners_and_control_method", "gas_type", "intake_tube_pressure", "per_btu", "total_btu", 
      "regulator", "work_area", "exterior_dimensions", "product_dimensions", "sink_bowl_dimensions", 
      "sink_depth", "leg_bracing", "faucet_and_drain"
    ]
    
    attrs = {}
    fields.each do |f|
      attrs[f] = row[f] if detail.respond_to?(f) && row[f].present?
    end
    
    detail.update!(attrs)
    
    # 处理富文本
    detail.standard_features = row["standard_features_html"] if row["standard_features_html"].present?
    detail.standard_features_zh = row["standard_features_zh_html"] if row["standard_features_zh_html"].present?
    detail.save!
  end

  def self.attach_images(sku, urls_str)
    return if urls_str.blank?
    
    urls = urls_str.split(",")
    urls.each do |url|
      url = url.strip
      next if url.blank?
      
      filename = File.basename(URI.parse(url).path)
      # 简单检查是否已存在同名图片
      next if sku.images.any? { |img| img.filename.to_s == filename }
      
      begin
        file = URI.open(url)
        sku.images.attach(io: file, filename: filename)
      rescue => e
        Rails.logger.warn "Failed to attach image from #{url}: #{e.message}"
      end
    end
  end

  def self.attach_file(sku, attachment_name, url)
    return if url.blank?
    
    attachment = sku.send(attachment_name)
    filename = File.basename(URI.parse(url).path)
    return if attachment.attached? && attachment.filename.to_s == filename
    
    begin
      file = URI.open(url)
      attachment.attach(io: file, filename: filename)
    rescue => e
      Rails.logger.warn "Failed to attach #{attachment_name} from #{url}: #{e.message}"
    end
  end
end
