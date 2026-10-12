require "test_helper"

class DealerApplicationTest < ActiveSupport::TestCase
  def setup
    @valid_attributes = {
      company_name: "Acme Kitchen Supplies LLC",
      contact_person: "John Doe",
      email: "john@acmekitchen.com",
      phone: "+1 555-123-4567",
      address: "123 Main St, Atlanta, GA 30301",
      website: "https://acmekitchen.com",
      business_type: "Restaurant Equipment Dealer",
      annual_purchase_volume: "$100,000–$250,000",
      product_categories: ["Commercial Refrigeration", "Commercial Cooking Equipment"],
      comments: "Interested in carrying your product lines."
    }
  end

  test "valid dealer application" do
    dealer_application = DealerApplication.new(@valid_attributes)
    assert dealer_application.valid?
  end

  test "invalid without required fields" do
    [:company_name, :contact_person, :email, :phone, :address, :business_type].each do |field|
      attrs = @valid_attributes.dup
      attrs.delete(field)
      dealer_app = DealerApplication.new(attrs)
      assert_not dealer_app.valid?, "Dealer application should be invalid without #{field}"
      assert_includes dealer_app.errors[field], "can't be blank"
    end
  end

  test "invalid with malformed email" do
    dealer_application = DealerApplication.new(@valid_attributes.merge(email: "invalid-email"))
    assert_not dealer_application.valid?
    assert_includes dealer_application.errors[:email], "is invalid"
  end

  test "product_categories_list helper returns array" do
    dealer_application = DealerApplication.new(@valid_attributes)
    assert_equal ["Commercial Refrigeration", "Commercial Cooking Equipment"], dealer_application.product_categories_list

    dealer_application.product_categories = nil
    assert_equal [], dealer_application.product_categories_list
  end
end
