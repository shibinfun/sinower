class CreateWarrantyInquiries < ActiveRecord::Migration[8.0]
  def change
    create_table :warranty_inquiries do |t|
      t.string :subject
      t.string :product_type
      t.string :model_number
      t.text :description
      t.string :name
      t.string :phone
      t.string :email
      t.string :status

      t.timestamps
    end
  end
end
