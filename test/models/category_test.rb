require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "should have many page views" do
    category = categories(:one)
    
    # Create associated page views
    3.times do |i|
      PageView.create!(
        page: category,
        page_name: category.name,
        ip: "192.168.1.#{i}",
        visited_at: Time.current
      )
    end
    
    assert_equal 3, category.page_views.count
    assert category.page_views.first.category?
  end
end
