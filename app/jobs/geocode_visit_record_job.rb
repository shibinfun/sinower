class GeocodeVisitRecordJob < ApplicationJob
  queue_as :default

  def perform(visit_record)
    return if visit_record.ip.blank?
    return if visit_record.ip == '127.0.0.1' || visit_record.ip == '::1'

    begin
      require 'net/http'
      require 'json'
      
      # 使用 ip-api.com 免费 API (注意: 免费版每分钟限制 45 次请求)
      url = URI("http://ip-api.com/json/#{visit_record.ip}?fields=status,message,country,regionName,city,district,zip,lat,lon,timezone,isp,org,as,query")
      response = Net::HTTP.get(url)
      data = JSON.parse(response)

      if data['status'] == 'success'
        visit_record.update_columns(
          country: data['country'],
          state:   data['regionName'],
          city:    data['city'],
          district: data['district'],
          address: [data['country'], data['regionName'], data['city'], data['district']].compact.reject(&:empty?).join(", ")
        )
      end
    rescue => e
      Rails.logger.error "IP Geocode Job Error for VisitRecord #{visit_record.id}: #{e.message}"
    end
  end
end
