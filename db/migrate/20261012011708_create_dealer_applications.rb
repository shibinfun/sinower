class CreateDealerApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :dealer_applications do |t|
      t.string :company_name
      t.string :contact_person
      t.string :email
      t.string :phone
      t.text :address
      t.string :website
      t.string :business_type
      t.string :business_type_other
      t.string :annual_purchase_volume
      t.text :product_categories
      t.string :product_categories_other
      t.text :comments
      t.string :status

      t.timestamps
    end
  end
end
