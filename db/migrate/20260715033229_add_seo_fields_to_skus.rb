class AddSeoFieldsToSkus < ActiveRecord::Migration[8.1]
  def change
    add_column :skus, :seo_title, :string
    add_column :skus, :seo_title_zh, :string
    add_column :skus, :seo_keywords, :string
    add_column :skus, :seo_keywords_zh, :string
    add_column :skus, :seo_description, :text
    add_column :skus, :seo_description_zh, :text
  end
end
