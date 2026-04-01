class CreateVisitRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :visit_records do |t|
      t.string :session_id
      t.string :ip
      t.string :country
      t.string :state
      t.string :city
      t.string :district
      t.string :address
      t.datetime :visit_time

      t.timestamps
    end
    add_index :visit_records, :session_id
    add_index :visit_records, [:session_id, :visit_time]
  end
end
