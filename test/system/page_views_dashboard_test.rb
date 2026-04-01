require "application_system_test_case"

class PageViewsDashboardTest < ApplicationSystemTestCase
  setup do
    @admin = users(:one)
    login_as(@admin, scope: :user)
    
    # Create test data
    @page_views = 10.times.map do |i|
      PageView.create!(
        page_type: i % 2 == 0 ? :sku : :category,
        page_name: "Product #{i}",
        ip: "192.168.1.#{i}",
        city: i % 3 == 0 ? "Shanghai" : "Beijing",
        visited_at: Time.current - i.hours,
        duration: 30 + i * 10
      )
    end
  end

  test "visiting the page views dashboard" do
    visit admin_page_views_url
    
    assert_selector "h1", text: /数据统计/
    assert_text "总访问量"
    assert_text "今日访问量"
    
    # Check stat cards are present
    assert_selector ".grid.grid-cols-1.md\\:grid-cols-4"
    
    # Check data table
    assert_selector "table"
    assert_text "Product 0"
  end

  test "filtering by page type" do
    visit admin_page_views_url
    
    # Filter by SKU
    select "SKU", from: "page_type"
    click_button "筛选"
    
    assert_text "Product 0" # Even numbers are SKUs
    refute_text "Product 1" # Odd numbers are categories
  end

  test "filtering by IP address" do
    visit admin_page_views_url
    
    fill_in "ip", with: "192.168.1.5"
    click_button "筛选"
    
    assert_text "192.168.1.5"
    refute_text "192.168.1.1"
  end

  test "filtering by city" do
    visit admin_page_views_url
    
    fill_in "city", with: "Shanghai"
    click_button "筛选"
    
    assert_text "Shanghai"
    refute_text "Beijing"
  end

  test "viewing top pages statistics" do
    visit admin_page_views_url
    
    # Should show top pages section
    assert_text /热门页面|Top Pages/i
    assert_text "Product 0"
  end

  test "pagination works" do
    # Create more records
    50.times do |i|
      PageView.create!(
        page_type: :sku,
        page_name: "Bulk Product #{i}",
        ip: "10.0.0.#{i}",
        visited_at: Time.current
      )
    end
    
    visit admin_page_views_url
    
    # Should see pagination
    assert_selector ".pagination"
    
    # Click next page
    click_link "Next" if has_link?("Next")
    
    # Should load new page
    assert_current_url(/page=2/)
  end

  test "responsive design on mobile" do
    resize_mobile
    
    visit admin_page_views_url
    
    # Mobile layout should stack cards
    assert_selector ".grid.grid-cols-1"
    
    # Table should be scrollable or responsive
    assert_selector "table"
  end

  private

  def resize_mobile
    page.driver.browser.resize_window(375, 667) # iPhone SE
  end
end
