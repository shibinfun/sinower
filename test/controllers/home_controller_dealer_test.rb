require "test_helper"

class HomeControllerDealerTest < ActionDispatch::IntegrationTest
  test "should get dealer page" do
    get dealer_url(locale: :en)
    assert_response :success
    assert_select "h1", text: /BECOME A SINOWER DEALER/i
  end

  test "should get dealer page with zh-CN locale" do
    get dealer_url(locale: "zh-CN")
    assert_response :success
    assert_select "h1", text: /成为 SINOWER 经销商/i
  end

  test "should submit dealer application successfully" do
    assert_difference("DealerApplication.count", 1) do
      post dealer_application_url(locale: :en), params: {
        privacy_agreement_dealer: "1",
        dealer_application: {
          company_name: "Test Dealer Inc",
          contact_person: "Alice Smith",
          email: "alice@testdealer.com",
          phone: "+1 555-987-6543",
          address: "456 Market St, Suite 100, City, State 12345",
          website: "https://testdealer.com",
          business_type: "Restaurant Equipment Dealer",
          annual_purchase_volume: "$50,000–$100,000",
          product_categories: ["Commercial Refrigeration"],
          comments: "Looking forward to partnership"
        }
      }
    end

    assert_redirected_to dealer_path
    follow_redirect!
    assert_response :success
    assert_select "div", text: /Application submitted successfully/i
  end

  test "should reject submission without privacy policy agreement" do
    assert_no_difference("DealerApplication.count") do
      post dealer_application_url(locale: :en), params: {
        privacy_agreement_dealer: "0",
        dealer_application: {
          company_name: "Test Dealer Inc",
          contact_person: "Alice Smith",
          email: "alice@testdealer.com",
          phone: "+1 555-987-6543",
          address: "456 Market St",
          business_type: "Restaurant Equipment Dealer"
        }
      }
    end

    assert_redirected_to dealer_path
  end
end
