module IpGeolocation
  extend ActiveSupport::Concern

  # 使用 ip-api.com 免费 API 解析 IP 地理位置
  def lookup_ip_location(ip)
    return {} if ip.blank? || ip == '127.0.0.1' || ip.start_with?('192.168.') || ip.start_with?('10.')
    
    begin
      response = HTTParty.get("http://ip-api.com/json/#{ip}", timeout: 3)
      if response.success? && response['status'] == 'success'
        {
          city: response['city'],
          province: response['regionName'],
          country: response['country']
        }
      else
        {}
      end
    rescue => e
      Rails.logger.warn "IP Geolocation failed for #{ip}: #{e.message}"
      {}
    end
  end

  def extract_ip_from_request(request)
    # 优先获取真实 IP（考虑 CDN、代理等情况）
    ip = request.headers['X-Forwarded-For'].to_s.split(',').first&.strip
    ip ||= request.headers['X-Real-IP']
    ip ||= request.remote_ip
    ip
  end
end
