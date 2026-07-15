require "test_helper"

class Admin::SkusControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:one)
    @sku = skus(:one)
    @sku.update!(slug: "test-sku") if @sku.slug.blank?
  end

  test "should get index" do
    sign_in @admin
    get admin_skus_url
    assert_response :success
  end

  test "should get edit with slug" do
    sign_in @admin
    
    get edit_admin_sku_url(id: @sku)
    assert_response :success
  end

  test "should get edit with id" do
    sign_in @admin
    get edit_admin_sku_url(id: @sku.id)
    assert_response :success
  end

  test "should update sku" do
    sign_in @admin
    patch admin_sku_url(id: @sku), params: { sku: { name: "Updated Sku Name" } }
    assert_redirected_to admin_skus_path
    @sku.reload
    assert_equal "Updated Sku Name", @sku.name
  end
end
