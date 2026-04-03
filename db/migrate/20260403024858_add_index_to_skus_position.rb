class AddIndexToSkusPosition < ActiveRecord::Migration[8.0]
  def change
    add_index :skus, :position
  end
end
