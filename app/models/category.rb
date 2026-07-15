class Category < ApplicationRecord
  has_many :children, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  has_many :skus, dependent: :destroy

  validates :name, presence: true
  validates :name_zh, presence: true
  validates :category_kind, presence: true, inclusion: { in: %w[a b c d] }
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/, message: "只能包含小写字母、数字和连字符" }
  
  before_validation :generate_slug
  
  scope :visible, -> { where(hidden: false) }
  validate :leaf_category_constraint_for_parent
  validate :consistent_category_kind

  def leaf?
    children.empty?
  end

  def depth
    parent ? parent.depth + 1 : 0
  end

  def all_descendant_skus
    if leaf?
      skus.order(position: :desc, created_at: :desc)
    else
      Sku.where(category_id: all_descendant_ids + [ id ]).order(position: :desc, created_at: :desc)
    end
  end

  def all_descendant_ids
    ids = []
    stack = children.visible.to_a
    while stack.any?
      child = stack.pop
      ids << child.id
      stack.concat(child.children.visible.to_a)
    end
    ids
  end

  def ancestors_and_self
    res = [ self ]
    node = self
    while node.parent
      node = node.parent
      res.unshift(node)
    end
    res
  end

  def localized_name
    I18n.locale == :"zh-CN" ? name_zh : name
  end

  def to_param
    slug.presence || id.to_s
  end

  private

  def generate_slug
    if slug.blank?
      self.slug = name.to_s.parameterize
    else
      self.slug = slug.parameterize
    end

    # If still blank (e.g. name only contains non-slug characters)
    if self.slug.blank?
      self.slug = "cat-#{SecureRandom.hex(4)}"
    end

    # Handle uniqueness if already taken
    if Category.where(slug: slug).where.not(id: id).exists?
      self.slug = "#{slug}-#{SecureRandom.hex(2)}"
    end
  end

  def leaf_category_constraint_for_parent
    return if parent_id.nil?

    if parent.skus.exists?
      errors.add(:parent_id, "该父分类下已有 SKU，无法在此添加子分类。")
    end
  end

  def consistent_category_kind
    if parent && category_kind != parent.category_kind
      errors.add(:category_kind, "必须与父分类的频道一致")
    end
  end
end
