class CreatePageViews < ActiveRecord::Migration[8.0]
  def change
    create_table :page_views do |t|
      t.integer :page_type, null: false  # 1=SKU, 2=Category, 3=Home, 4=Product List
      t.integer :page_id                   # 对应资源的 ID
      t.string :page_name                  # 页面名称/SKU 名称
      t.string :ip, null: false
      t.string :city
      t.string :province
      t.string :country
      t.text :user_agent
      t.string :referer
      t.string :session_id
      t.datetime :visited_at, null: false
      t.integer :duration, default: 0      # 浏览时长 (秒)

      t.timestamps
    end
    
    add_index :page_views, :page_type
    add_index :page_views, :page_id
    add_index :page_views, :session_id
    add_index :page_views, :visited_at
    add_index :page_views, :ip
  end
end
