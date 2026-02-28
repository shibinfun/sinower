class CreateSkus < ActiveRecord::Migration[8.0]
  def change
    create_table :skus do |t|
      t.string :name
      t.string :net_capacity
      t.string :unit_dimensions
      t.string :packaging_dimensions
      t.string :voltage_frequency
      t.string :temp_range
      t.text :standard_features
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
