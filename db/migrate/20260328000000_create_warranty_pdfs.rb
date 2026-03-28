class CreateWarrantyPdfs < ActiveRecord::Migration[8.0]
  def change
    create_table :warranty_pdfs do |t|
      t.string :name, null: false
      t.string :pdf_type, null: false, index: { unique: true }
      t.string :description
      
      t.timestamps
    end
    
    add_index :warranty_pdfs, :name
  end
end
