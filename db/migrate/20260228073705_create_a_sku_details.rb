class CreateASkuDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :a_sku_details do |t|
      t.string :net_capacity
      t.string :unit_dimensions
      t.string :packaging_dimensions
      t.string :voltage_frequency
      t.string :temp_range
      t.text :standard_features

      t.timestamps
    end
  end
end
