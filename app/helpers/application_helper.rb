module ApplicationHelper
  def categories_for_kind(kind)
    Category.where(category_kind: kind, parent_id: nil).includes(children: { children: { children: { children: :children } } })
  end
end
