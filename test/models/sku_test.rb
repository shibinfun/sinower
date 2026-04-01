require "test_helper"

class SkuTest < ActiveSupport::TestCase
  test "should have many page views" do
    sku = skus(:one)
    
    # Create associated page views
    3.times do |i|
      PageView.create!(
        page: sku,
        page_name: sku.name,
        ip: "192.168.1.#{i}",
        visited_at: Time.current
      )
    end
    
    assert_equal 3, sku.page_views.count
    assert sku.page_views.first.sku?
  end

  test "should get popular SKUs by view count" do
    sku1 = skus(:one)
    sku2 = skus(:two)
    
    # Create more views for sku1
    5.times do
      PageView.create!(
        page: sku1,
        page_name: sku1.name,
        visited_at: Time.current
      )
    end
    
    2.times do
      PageView.create!(
        page: sku2,
        page_name: sku2.name,
        visited_at: Time.current
      )
    end
    
    # Get most viewed SKU
    popular_sku_id = PageView.where(page_type: :sku)
                             .group(:page_id)
                             .count
                             .max_by { |_, count| count }
                             &.first
    
    assert_equal sku1.id, popular_sku_id
  end
end
