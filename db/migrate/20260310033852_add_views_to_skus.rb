class AddViewsToSkus < ActiveRecord::Migration[8.0]
  def change
    add_column :skus, :views, :integer, default: 0
  end
end
