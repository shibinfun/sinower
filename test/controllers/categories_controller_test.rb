require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should redirect if category not found" do
    get categories_url(category_id: 999999)
    assert_redirected_to categories_path
    follow_redirect!
    assert_match "未找到指定的分类", response.body
  end

  test "should redirect to slug if category accessed by ID" do
    @category = categories(:one)
    @category.update!(slug: 'test-slug-1')
    get categories_url(category_id: @category.id)
    assert_response :moved_permanently
    assert_redirected_to category_path(slug: @category.slug)
  end

  test "should get show via slug" do
    @category = categories(:one)
    @category.update!(slug: 'test-slug-show')
    get category_url(slug: @category.slug)
    assert_response :success
    assert_select "h1", text: /#{@category.localized_name}/
  end

  test "should redirect show via ID to slug" do
    @category = categories(:one)
    @category.update!(slug: 'test-slug-redirect')
    get category_url(slug: @category.id)
    assert_response :moved_permanently
    assert_redirected_to category_path(slug: @category.slug)
  end

  test "should handle common missing routes" do
    get "/apple-touch-icon.png"
    assert_response :not_found

    get "/wp-includes/something"
    assert_response :not_found

    get "/product-page/something"
    assert_response :not_found
  end
end
