class CreateCSkuDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :c_sku_details do |t|
      t.string :burners_and_control_method
      t.string :gas_type
      t.string :intake_tube_pressure
      t.string :per_btu
      t.string :total_btu
      t.string :regulator
      t.string :work_area
      t.string :exterior_dimensions
      t.text :key_features

      t.timestamps
    end
  end
end
