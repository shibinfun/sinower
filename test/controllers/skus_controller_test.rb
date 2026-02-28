require "test_helper"

class SkusControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get skus_show_url
    assert_response :success
  end
end
