class CreateVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :visits do |t|
      t.string :page_name
      t.string :page_url
      t.string :ip_address
      t.text :user_agent
      t.string :referer
      t.string :country
      t.string :region
      t.string :city
      t.string :isp
      t.datetime :visited_at

      t.timestamps
    end
    
    add_index :visits, :visited_at
    add_index :visits, :ip_address
    add_index :visits, :page_url
    add_index :visits, [:country, :region, :city]
  end
end
