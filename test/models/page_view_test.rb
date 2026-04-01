require "test_helper"

class PageViewTest < ActiveSupport::TestCase
  test "should create page view" do
    assert_difference("PageView.count", 1) do
      PageView.create!(
        page_type: :sku,
        page_name: "Test Product",
        ip: "127.0.0.1",
        visited_at: Time.current,
        duration: 30
      )
    end
  end

  test "page_type enum should work correctly" do
    pv = PageView.create!(
      page_type: :sku,
      page_name: "Test",
      ip: "127.0.0.1",
      visited_at: Time.current
    )
    assert pv.sku?
    refute pv.category?
    
    pv.update!(page_type: :category)
    assert pv.category?
    refute pv.sku?
  end

  test "should calculate duration formatted" do
    pv = PageView.create!(
      page_type: :sku,
      page_name: "Test",      ip: "127.0.0.1",      visited_at: Time.current,
      duration: nil
    )
    assert_equal "0s", pv.duration_formatted
    
    pv.update!(duration: 5)
    assert_equal "5s", pv.duration_formatted
    
    pv.update!(duration: 75)
    assert_equal "1m 15s", pv.duration_formatted
    
    pv.update!(duration: 3665)
    assert_equal "1h 1m 5s", pv.duration_formatted
  end

  test "should scope recent records" do
    PageView.delete_all
    old_pv = PageView.create!(
      page_type: :sku,
      page_name: "Old",
      ip: "127.0.0.1",
      visited_at: 1.day.ago
    )
    new_pv = PageView.create!(
      page_type: :sku,
      page_name: "New",
      ip: "127.0.0.1",
      visited_at: Time.current
    )
    
    recent = PageView.recent.limit(1)
    assert_equal new_pv, recent.first
  end

  test "should scope today's records" do
    PageView.delete_all
    yesterday_pv = PageView.create!(
      page_type: :sku,
      page_name: "Yesterday",
      ip: "127.0.0.1",
      visited_at: 1.day.ago
    )
    today_pv = PageView.create!(
      page_type: :sku,
      page_name: "Today",
      ip: "127.0.0.1",
      visited_at: Time.current
    )
    
    today_views = PageView.today
    assert_includes today_views, today_pv
    refute_includes today_views, yesterday_pv
  end

  test "should record geolocation data" do
    pv = PageView.create!(
      page_type: :sku,
      page_name: "Test",
      ip: "8.8.8.8",
      city: "Mountain View",
      province: "California",
      country: "United States",
      visited_at: Time.current
    )
    
    assert_equal "Mountain View", pv.city
    assert_equal "California", pv.province
    assert_equal "United States", pv.country
  end
end
