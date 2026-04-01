class CreatePageViews < ActiveRecord::Migration[8.0]
  def change
    create_table :page_views do |t|
      t.integer :page
      t.string :ip
      t.string :city
      t.string :province
      t.string :country
      t.text :user_agent
      t.string :referer
      t.string :session_id
      t.datetime :visited_at
      t.integer :duration

      t.timestamps
    end
  end
end
