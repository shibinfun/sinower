class AddSlugToCategoriesAndSkus < ActiveRecord::Migration[8.1]
  def change
    add_column :categories, :slug, :string
    add_index :categories, :slug, unique: true
    add_column :skus, :slug, :string
    add_index :skus, :slug, unique: true
  end
end
