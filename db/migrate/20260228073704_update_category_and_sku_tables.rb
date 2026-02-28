class UpdateCategoryAndSkuTables < ActiveRecord::Migration[8.0]
  def change
    # Update categories table
    add_column :categories, :category_kind, :string

    # Update skus table - drop specific fields and add polymorphic fields
    remove_column :skus, :net_capacity, :string
    remove_column :skus, :unit_dimensions, :string
    remove_column :skus, :packaging_dimensions, :string
    remove_column :skus, :voltage_frequency, :string
    remove_column :skus, :temp_range, :string
    remove_column :skus, :standard_features, :text

    add_column :skus, :price, :decimal, precision: 10, scale: 2
    add_column :skus, :stock, :integer, default: 0
    add_column :skus, :status, :string, default: 'draft'
    add_column :skus, :visible, :boolean, default: true
    add_column :skus, :skuable_type, :string
    add_column :skus, :skuable_id, :integer
    add_index :skus, [:skuable_type, :skuable_id]
  end
end
