class PageView < ApplicationRecord
  include IpGeolocation

  # Store page type as enum (0=other, 1=sku, 2=category, 3=home, 4=product_list)
  enum :page_type, [:other, :sku, :category, :home, :product_list]

  scope :recent, -> { order(visited_at: :desc) }
  scope :today, -> { where('visited_at >= ?', Time.current.beginning_of_day) }
  scope :this_week, -> { where('visited_at >= ?', Time.current.beginning_of_week) }
  scope :this_month, -> { where('visited_at >= ?', Time.current.beginning_of_month) }

  def duration_formatted
    return '0s' if duration.blank? || duration < 1
    
    if duration < 60
      "#{duration}s"
    elsif duration < 3600
      "#{duration / 60}m #{duration % 60}s"
    else
      "#{duration / 3600}h #{(duration % 3600) / 60}m"
    end
  end

  def device_type
    ua = user_agent.to_s
    if ua.match?(/Mobile|Android|iPhone|iPad|iPod/i)
      'mobile'
    elsif ua.match?(/Tablet|iPad/i)
      'tablet'
    else
      'desktop'
    end
  end

  def browser_name
    ua = user_agent.to_s
    case
    when ua.match?(/Chrome/i) && !ua.match?(/Edg/i)
      'Chrome'
    when ua.match?(/Firefox/i)
      'Firefox'
    when ua.match?(/Safari/i) && !ua.match?(/Chrome/i)
      'Safari'
    when ua.match?(/Edg/i)
      'Edge'
    when ua.match?(/MSIE|Trident/i)
      'Internet Explorer'
    else
      'Unknown'
    end
  end

  def os_name
    ua = user_agent.to_s
    case
    when ua.match?(/Windows NT/i)
      'Windows'
    when ua.match?(/Mac OS X/i)
      'macOS'
    when ua.match?(/Linux/i)
      'Linux'
    when ua.match?(/Android/i)
      'Android'
    when ua.match?(/iOS/i)
      'iOS'
    else
      'Unknown'
    end
  end
end
