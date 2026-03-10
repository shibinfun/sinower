class RemoveKeyFeaturesFromCSkuDetails < ActiveRecord::Migration[8.0]
  def change
    remove_column :c_sku_details, :key_features, :text
  end
end
