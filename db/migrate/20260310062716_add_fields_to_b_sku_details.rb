class AddFieldsToBSkuDetails < ActiveRecord::Migration[8.0]
  def change
    add_column :b_sku_details, :burners_and_control_method, :string
    add_column :b_sku_details, :gas_type, :string
    add_column :b_sku_details, :intake_tube_pressure, :string
    add_column :b_sku_details, :per_btu, :string
    add_column :b_sku_details, :total_btu, :string
    add_column :b_sku_details, :regulator, :string
    add_column :b_sku_details, :work_area, :string
    add_column :b_sku_details, :exterior_dimensions, :string
  end
end
