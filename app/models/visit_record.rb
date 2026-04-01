class VisitRecord < ApplicationRecord
  validates :session_id, presence: true
  
  before_validation :set_visit_time, on: :create
  before_create :fill_geoinfo

  private

  def set_visit_time
    self.visit_time ||= Time.current
  end

  def fill_geoinfo
    return if ip.blank?
    return if ip == '127.0.0.1' || ip == '::1'

    begin
      require 'net/http'
      require 'json'
      
      # 使用 ip-api.com 免费 API (注意: 免费版每分钟限制 45 次请求)
      url = URI("http://ip-api.com/json/#{ip}?fields=status,message,country,regionName,city,district,zip,lat,lon,timezone,isp,org,as,query")
      response = Net::HTTP.get(url)
      data = JSON.parse(response)

      if data['status'] == 'success'
        self.country = data['country']
        self.state   = data['regionName']
        self.city    = data['city']
        self.district = data['district']
        self.address = [data['country'], data['regionName'], data['city'], data['district']].compact.reject(&:empty?).join(", ")
      end
    rescue => e
      Rails.logger.error "IP Geocode Error: #{e.message}"
    end
  end

  public

  def device_info
    return "未知" if user_agent.blank?
    
    ua = user_agent.downcase
    if ua.include?('iphone') || ua.include?('ipad')
      "iOS 设备"
    elsif ua.include?('android')
      "Android 设备"
    elsif ua.include?('windows')
      "Windows PC"
    elsif ua.include?('macintosh')
      "Mac PC"
    elsif ua.include?('linux')
      "Linux PC"
    else
      "其他设备"
    end
  end
end
