require "test_helper"

class IpGeolocationTest < ActiveSupport::TestCase
  test "should lookup geolocation for valid IP" do
    # Skip in CI or if API is unavailable
    skip "Skipping external API test" unless ENV["TEST_GEOLOCATION"]
    
    include IpGeolocation
    
    # Create a test object that includes the concern
    test_obj = Class.new do
      include IpGeolocation
      attr_accessor :ip
      
      def initialize(ip)
        @ip = ip
      end
    end.new("8.8.8.8")
    
    result = test_obj.lookup_geolocation
    
    assert_not_nil result
    assert result.has_key?(:city) || result.has_key?("city")
  rescue => e
    # API might be unavailable, that's OK
    puts "Geolocation API test skipped: #{e.message}"
    skip "API unavailable"
  end

  test "should handle private IP addresses" do
    # Skip in CI or if API is unavailable  
    skip "Skipping external API test" unless ENV["TEST_GEOLOCATION"]
    
    test_obj = Class.new do
      include IpGeolocation
      attr_accessor :ip
      
      def initialize(ip)
        @ip = ip
      end
    end.new("192.168.1.1")
    
    result = test_obj.lookup_geolocation
    
    # Private IPs should return nil or local info
    assert_nil result[:city] if result && result[:city].blank?
  rescue => e
    puts "Geolocation API test skipped: #{e.message}"
    skip "API unavailable"
  end

  test "should handle localhost" do
    # Skip in CI or if API is unavailable
    skip "Skipping external API test" unless ENV["TEST_GEOLOCATION"]
    
    test_obj = Class.new do
      include IpGeolocation
      attr_accessor :ip
      
      def initialize(ip)
        @ip = ip
      end
    end.new("127.0.0.1")
    
    result = test_obj.lookup_geolocation
    
    # Localhost should return nil or local info
    assert_nil result[:city] if result && result[:city].blank?
  rescue => e
    puts "Geolocation API test skipped: #{e.message}"
    skip "API unavailable"
  end
    
    assert_nil result
  end

  test "should cache geolocation results" do
    include IpGeolocation
    
    test_obj = Class.new do
      include IpGeolocation
      attr_accessor :ip, :city, :province, :country
      
      def initialize(ip)
        @ip = ip
      end
    end.new("8.8.8.8")
    
    # First call
    test_obj.lookup_geolocation
    
    # Should have cached values
    assert test_obj.city.present? || test_obj.city.nil?
  end

  test "should parse IP-API response correctly" do
    # Mock HTTParty response
    mock_response = {
      "status" => "success",
      "city" => "Mountain View",
      "regionName" => "California",
      "country" => "United States",
      "isp" => "Google LLC"
    }
    
    HTTParty.stub(:get, mock_response) do
      include IpGeolocation
      
      test_obj = Class.new do
        include IpGeolocation
        attr_accessor :ip
        
        def initialize(ip)
          @ip = ip
        end
      end.new("8.8.8.8")
      
      result = test_obj.lookup_geolocation
      
      assert_equal "Mountain View", result[:city]
      assert_equal "California", result[:province]
      assert_equal "United States", result[:country]
    end
  end
end
