class AddNameZhToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :name_zh, :string
  end
end
