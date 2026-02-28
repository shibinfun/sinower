class CreateBSkuDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :b_sku_details do |t|
      t.string :unit_dimensions

      t.timestamps
    end
  end
end
