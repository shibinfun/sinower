class Sku < ApplicationRecord
  belongs_to :category
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  
  def sorted_images
    images_attachments.includes(:blob).order(:position, :created_at)
  end

  def to_param
    slug.presence || id.to_s
  end
  has_one_attached :manual
  has_one_attached :spec_sheet

  delegated_type :skuable, types: %w[ ASkuDetail BSkuDetail CSkuDetail ], dependent: :destroy
  accepts_nested_attributes_for :skuable

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/, message: "只能包含小写字母、数字和连字符" }
  validates :position, numericality: { only_integer: true }
  
  before_validation :generate_slug
  before_validation :build_default_skuable

  private

  def images_must_be_bmp_or_png_jpg_images
    return unless images.attached?

    images.each do |image|
      unless image.content_type.in?(%w[image/jpeg image/jpg image/png image/gif image/webp image/bmp])
        errors.add(:images, "只能上传图片文件 (JPEG, PNG, GIF, WebP, BMP)，但 '#{image.filename}' 的类型是 #{image.content_type}")
      end

      if image.byte_size > 30.megabytes
        errors.add(:images, "文件 '#{image.filename}' 太大 (最大 30MB)，当前大小为 #{(image.byte_size / 1.0.megabyte).round(2)}MB")
      end
    end
  end

  def manual_and_spec_sheet_must_be_pdf
    if manual.attached?
      if !manual.content_type.start_with?('application/pdf')
        errors.add(:manual, "说明书必须是 PDF 格式")
      end
      if manual.byte_size > 30.megabytes
        errors.add(:manual, "说明书文件太大 (最大 30MB)，当前大小为 #{(manual.byte_size / 1.0.megabyte).round(2)}MB")
      end
    end

    if spec_sheet.attached?
      if !spec_sheet.content_type.start_with?('application/pdf')
        errors.add(:spec_sheet, "规格表必须是 PDF 格式")
      end
      if spec_sheet.byte_size > 30.megabytes
        errors.add(:spec_sheet, "规格表文件太大 (最大 30MB)，当前大小为 #{(spec_sheet.byte_size / 1.0.megabyte).round(2)}MB")
      end
    end
  end

  def category_must_be_leaf
    return if category.nil?

    unless category.leaf?
      errors.add(:category_id, "SKU 只能挂在最底层的叶子分类上。")
    end
  end

  def skuable_type_matches_category_kind
    return if category.nil? || skuable_type.nil?

    expected_type = "#{category.category_kind.upcase}SkuDetail"
    if skuable_type != expected_type
      errors.add(:skuable_type, "必须与分类的频道 (#{category.category_kind}) 匹配")
    end
  end

  def build_default_skuable
    return if category.nil?
    
    # If category kind changed, we might need to clear or change skuable.
    # But usually, it's safer to just build if missing.
    return if skuable.present? || skuable_type.present?

    case category.category_kind
    when 'a'
      self.skuable = ASkuDetail.new
    when 'b'
      self.skuable = BSkuDetail.new
    when 'c'
      self.skuable = CSkuDetail.new
    end
  end

  def generate_slug
    if slug.blank?
      self.slug = name.to_s.parameterize
    else
      self.slug = slug.parameterize
    end

    # If still blank
    if self.slug.blank?
      self.slug = "sku-#{SecureRandom.hex(4)}"
    end

    # Handle uniqueness if already taken
    if Sku.where(slug: slug).where.not(id: id).exists?
      self.slug = "#{slug}-#{SecureRandom.hex(2)}"
    end
  end
end
