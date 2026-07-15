require "test_helper"

class Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:one)
    @category = categories(:one)
    @category.update!(slug: "test-category") if @category.slug.blank?
  end

  test "should get index" do
    sign_in @admin
    get admin_categories_url
    assert_response :success
  end

  test "should get edit with slug" do
    sign_in @admin
    
    get edit_admin_category_url(id: @category)
    assert_response :success
  end

  test "should get edit with id" do
    sign_in @admin
    get edit_admin_category_url(id: @category.id)
    assert_response :success
  end

  test "should update category" do
    sign_in @admin
    patch admin_category_url(id: @category), params: { category: { name: "Updated Name" } }
    assert_redirected_to admin_categories_path
    @category.reload
    assert_equal "Updated Name", @category.name
  end
end
