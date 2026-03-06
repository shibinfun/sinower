class AddStandardFeaturesToBSkuDetails < ActiveRecord::Migration[8.0]
  def change
    add_column :b_sku_details, :standard_features, :text
  end
end
