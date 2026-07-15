require "test_helper"

class SkusControllerTest < ActionDispatch::IntegrationTest
  test "should get show with slug" do
    @sku = skus(:one)
    @sku.save! # 确保生成了 slug
    get sku_url(slug: @sku.slug)
    assert_response :success
  end

  test "should redirect from id to slug" do
    @sku = skus(:one)
    @sku.save!
    get sku_url(slug: @sku.id)
    assert_response :moved_permanently
    assert_redirected_to sku_url(slug: @sku.slug)
  end
end
