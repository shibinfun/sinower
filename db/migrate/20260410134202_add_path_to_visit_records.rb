class AddPathToVisitRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :visit_records, :path, :string
  end
end
