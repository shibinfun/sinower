class RemoveViewsFromSkus < ActiveRecord::Migration[8.0]
  def change
    remove_column :skus, :views, :integer
  end
end
