require "test_helper"

class Admin::SettingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:one)
  end

  test "should get show when logged in as admin" do
    sign_in @admin
    get admin_settings_url
    assert_response :success
    assert_select "h2", text: /首页 SEO 配置/
  end

  test "should redirect show when not logged in" do
    get admin_settings_url
    assert_response :redirect
  end
end
