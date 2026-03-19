class Sku < ApplicationRecord
  belongs_to :category
  has_many_attached :images
  has_one_attached :manual
  has_one_attached :spec_sheet

  delegated_type :skuable, types: %w[ ASkuDetail BSkuDetail CSkuDetail ], dependent: :destroy
  accepts_nested_attributes_for :skuable

  validates :name, presence: true
  validate :category_must_be_leaf
  validate :skuable_type_matches_category_kind

  before_validation :build_default_skuable, on: :create

  private

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
    return if category.nil? || skuable.present? || skuable_type.present?

    case category.category_kind
    when 'a'
      self.skuable = ASkuDetail.new
    when 'b'
      self.skuable = BSkuDetail.new
    when 'c'
      self.skuable = CSkuDetail.new
    end
  end
end
