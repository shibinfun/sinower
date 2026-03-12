class AddStandardFeaturesZhToSkuDetails < ActiveRecord::Migration[8.0]
  def change
    add_column :a_sku_details, :standard_features_zh, :text
    add_column :b_sku_details, :standard_features_zh, :text
    add_column :c_sku_details, :standard_features_zh, :text
  end
end
