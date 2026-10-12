require "test_helper"

class AdminDealerApplicationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin_user = User.create!(
      email: "admin_dealer_test@example.com",
      password: "password123",
      admin: true
    )
    @dealer_app = DealerApplication.create!(
      company_name: "Test Corp",
      contact_person: "Bob",
      email: "bob@testcorp.com",
      phone: "1234567890",
      address: "123 Street",
      business_type: "Wholesale Distributor"
    )
  end

  test "admin can view dealer applications list" do
    sign_in @admin_user
    get admin_dealer_applications_url(locale: :en)
    assert_response :success
    assert_select "td", text: /Test Corp/
  end

  test "admin can view single dealer application" do
    sign_in @admin_user
    get admin_dealer_application_url(locale: :en, id: @dealer_app.id)
    assert_response :success
    assert_select "div", text: /Test Corp/
  end

  test "admin can delete dealer application" do
    sign_in @admin_user
    assert_difference("DealerApplication.count", -1) do
      delete admin_dealer_application_url(locale: :en, id: @dealer_app.id)
    end
    assert_redirected_to admin_dealer_applications_path
  end
end
