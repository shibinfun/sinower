require "test_helper"

class SkusControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    @sku = skus(:one)
    get sku_url(id: @sku.id)
    assert_response :success
  end
end
