require "test_helper"

class Admin::PageViewsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @admin = users(:one)
    # Ensure admin flag is set and reload
    @admin.update!(admin: true)
    @admin.reload
    sign_in @admin
    
    # Create test data
    @page_view = PageView.create!(
      page_type: :sku,
      page_name: "Test SKU",
      ip: "192.168.1.100",
      city: "Shanghai",
      visited_at: Time.current,
      duration: 45
    )
  end
  
  teardown do
    # Clean up to avoid cross-test contamination
    PageView.delete_all
  end

  test "should get index" do
    get admin_page_views_url
    assert_response :success
    assert_select "div.bg-white.p-6.rounded-xl", count: 4 # Stat cards
    assert_select "table", count: 1 # Data table
  end

  test "should display total views" do
    get admin_page_views_url
    assert_response :success
    assert_match /总访问量/, response.body
    assert_match /#{@page_view.page_name}/, response.body
  end

  test "should filter by page_type" do
    create_category_page_view
    
    get admin_page_views_url, params: { page_type: "sku" }
    assert_response :success
    assert_select "td", text: "Test SKU"
    
    get admin_page_views_url, params: { page_type: "category" }
    assert_response :success
    assert_select "td", text: "Test Category"
  end

  test "should filter by IP address" do
    create_different_ip_view
    
    get admin_page_views_url, params: { ip: "192.168.1.100" }
    assert_response :success
    assert_select "td", text: "Test SKU"
    
    get admin_page_views_url, params: { ip: "10.0.0.1" }
    assert_response :success
    refute_match /Test SKU/, response.body
  end

  test "should filter by city" do
    create_different_city_view
    
    get admin_page_views_url, params: { city: "Shanghai" }
    assert_response :success
    assert_select "td", text: "Shanghai"
    
    get admin_page_views_url, params: { city: "Beijing" }
    assert_response :success
    refute_match /Shanghai/, response.body
  end

  test "should filter by date range" do
    old_view = create_old_page_view
    
    get admin_page_views_url, params: { 
      date_from: (Time.current - 1.hour).strftime("%Y-%m-%d"),
      date_to: Time.current.strftime("%Y-%m-%d")
    }
    assert_response :success
    assert_select "td", text: "Test SKU"
    refute_match /Old Product/, response.body
  end

  test "should show pagination" do
    # Create 60 records to trigger pagination
    59.times do |i|
      PageView.create!(
        page_type: :sku,
        page_name: "Product #{i}",
        ip: "192.168.1.#{i % 255}",
        visited_at: Time.current
      )
    end
    
    get admin_page_views_url
    assert_response :success
    assert_select ".pagination"
  end

  test "should calculate statistics correctly" do
    get admin_page_views_url
    assert_response :success
    
    # Check that stats are rendered
    assert_select "div.grid.grid-cols-1.md\\:grid-cols-4"
  end

  test "should require authentication" do
    sign_out @admin
    reload_page_views
    
    get admin_page_views_url
    assert_redirected_to new_user_session_url
  end
  
  def reload_page_views
    # Helper to ensure clean state between tests
    PageView.delete_all
  end

  test "should show top pages" do
    # Create multiple views for different products
    5.times { create_page_view(page_name: "Popular Product", page_type: :sku) }
    2.times { create_page_view(page_name: "Less Popular", page_type: :sku) }
    
    get admin_page_views_url
    assert_response :success
    assert_match /Popular Product/, response.body
  end

  private

  def create_page_view(attributes = {})
    PageView.create!(attributes.reverse_merge(
      page_type: :sku,
      page_name: "Test Product",
      ip: "127.0.0.1",
      visited_at: Time.current
    ))
  end

  def create_category_page_view
    PageView.create!(
      page_type: :category,
      page_name: "Test Category",
      ip: "192.168.1.101",
      visited_at: Time.current
    )
  end

  def create_different_ip_view
    PageView.create!(
      page_type: :sku,
      page_name: "Different IP",
      ip: "10.0.0.1",
      visited_at: Time.current
    )
  end

  def create_different_city_view
    PageView.create!(
      page_type: :sku,
      page_name: "Different City",
      ip: "192.168.1.102",
      city: "Beijing",
      visited_at: Time.current
    )
  end

  def create_old_page_view
    PageView.create!(
      page_type: :sku,
      page_name: "Old Product",
      ip: "192.168.1.103",
      visited_at: 2.days.ago
    )
  end
end
