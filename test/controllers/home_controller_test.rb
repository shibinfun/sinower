require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should get robots.txt" do
    get "/robots.txt"
    assert_response :success
    assert_match /User-agent/, response.body
  end

  test "should get sitemap.xml when configured" do
    Setting.set('sitemap', '<?xml version="1.0" encoding="UTF-8"?><urlset></urlset>')
    get "/sitemap.xml"
    assert_response :success
    assert_match /urlset/, response.body
  end

  test "should return 404 for sitemap.xml when not configured" do
    Setting.find_by(key: 'sitemap')&.destroy
    get "/sitemap.xml"
    assert_response :not_found
  end
end
