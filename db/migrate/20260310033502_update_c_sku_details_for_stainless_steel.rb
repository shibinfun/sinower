class UpdateCSkuDetailsForStainlessSteel < ActiveRecord::Migration[8.0]
  def change
    change_table :c_sku_details do |t|
      # Common fields
      t.string :unit_dimensions # Existing: exterior_dimensions (will map)
      
      # For Sinks
      t.string :product_dimensions
      t.string :sink_bowl_dimensions
      t.string :sink_depth
      t.string :leg_bracing
      
      # For Faucet/Drain
      t.string :faucet_and_drain
      
      # Features
      t.text :standard_features
    end
  end
end
