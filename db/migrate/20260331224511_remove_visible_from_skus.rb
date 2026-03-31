class RemoveVisibleFromSkus < ActiveRecord::Migration[8.0]
  def change
    remove_column :skus, :visible, :boolean
  end
end
