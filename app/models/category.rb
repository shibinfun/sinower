class Category < ApplicationRecord
  has_many :children, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  has_many :skus, dependent: :destroy

  validates :name, presence: true
  validates :name_zh, presence: true
  validates :category_kind, presence: true, inclusion: { in: %w[a b c d] }
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
      skus
    else
      Sku.where(category_id: all_descendant_ids + [ id ])
    end
  end

  def all_descendant_ids
    ids = []
    stack = children.to_a
    while stack.any?
      child = stack.pop
      ids << child.id
      stack.concat(child.children.to_a)
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

  private

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
