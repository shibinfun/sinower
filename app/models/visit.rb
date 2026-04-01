class Visit < ApplicationRecord
  # 批量插入优化性能
  def self.record_visit(page_name, page_url, request)
    ip_address = extract_ip_from(request)
    user_agent = request.user_agent
    referer = request.referer
    
    # 简单的 IP 地址地理位置解析（可以使用 gem 如 'maxmind-geolite2' 或 API）
    location = lookup_location(ip_address)
    
    create!(
      page_name: page_name,
      page_url: page_url,
      ip_address: ip_address,
      user_agent: user_agent,
      referer: referer,
      country: location[:country],
      region: location[:region],
      city: location[:city],
      isp: location[:isp],
      visited_at: Time.current
    )
  rescue => e
    Rails.logger.error "Failed to record visit: #{e.message}"
  end
  
  def self.extract_ip_from(request)
    # 考虑代理情况
    ips = request.env['HTTP_X_FORWARDED_FOR']
    ips ? ips.split(',').first.strip : request.remote_ip
  end
  
  def self.lookup_location(ip_address)
    # 简化的地理位置查找
    # 生产环境建议使用：maxmind-geolite2 gem 或 IP2Location API
    {
      country: nil,
      region: nil,
      city: nil,
      isp: nil
    }
  end
  
  # 统计查询作用域
  scope :today, -> { where(visited_at: Time.zone.beginning_of_day..Time.zone.end_of_day) }
  scope :yesterday, -> { where(visited_at: 1.day.ago.beginning_of_day..1.day.ago.end_of_day) }
  scope :this_week, -> { where(visited_at: Time.zone.beginning_of_week..Time.zone.end_of_week) }
  scope :this_month, -> { where(visited_at: Time.zone.beginning_of_month..Time.zone.end_of_month) }
  scope :by_page, ->(page_url) { where(page_url: page_url) }
  scope :by_country, ->(country) { where(country: country) }
  
  # 按页面分组统计
  def self.page_stats(start_date = nil, end_date = nil)
    query = all
    query = query.where(visited_at: start_date..end_date) if start_date && end_date
    
    query.group(:page_url, :page_name)
         .select(:page_url, :page_name, 'COUNT(*) as views')
         .order('views DESC')
  end
  
  # 按国家统计
  def self.country_stats(start_date = nil, end_date = nil)
    query = all
    query = query.where(visited_at: start_date..end_date) if start_date && end_date
    
    query.group(:country)
         .select(:country, 'COUNT(*) as visits')
         .order('visits DESC')
  end
  
  # 按城市统计
  def self.city_stats(start_date = nil, end_date = nil)
    query = all
    query = query.where(visited_at: start_date..end_date) if start_date && end_date
    
    query.group(:country, :region, :city)
         .select(:country, :region, :city, 'COUNT(*) as visits')
         .order('visits DESC')
  end
  
  # 按 IP 统计（独立访客）
  def self.unique_visitors(start_date = nil, end_date = nil)
    query = all
    query = query.where(visited_at: start_date..end_date) if start_date && end_date
    
    query.distinct.count(:ip_address)
  end
  
  # 每小时访问量
  def self.hourly_stats(date = Date.today)
    where(visited_at: date.beginning_of_day..date.end_of_day)
      .group("DATE_TRUNC('hour', visited_at)")
      .select("DATE_TRUNC('hour', visited_at) as hour, COUNT(*) as visits")
      .order('hour ASC')
  end
  
  # 每日访问量
  def self.daily_stats(days = 30)
    where(visited_at: days.days.ago..Time.current)
      .group("DATE(visited_at)")
      .select("DATE(visited_at) as date, COUNT(*) as visits")
      .order('date ASC')
  end
end
