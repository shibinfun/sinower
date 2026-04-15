class AddHiddenToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :hidden, :boolean, default: false, null: false
  end
end
