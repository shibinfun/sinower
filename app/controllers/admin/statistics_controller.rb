module Admin
  class StatisticsController < BaseController
    def index
      @period = params[:period] || 'today'
      @start_date, @end_date = parse_period(@period)
      
      # 总体统计
      @total_visits = Visit.where(visited_at: @start_date..@end_date).count
      @unique_visitors = Visit.unique_visitors(@start_date, @end_date)
      @avg_views_per_visitor = (@total_visits.to_f / [@unique_visitors, 1].max).round(2)
      
      # 页面统计
      @page_stats = Visit.page_stats(@start_date, @end_date).limit(20)
      
      # 地域统计
      @country_stats = Visit.country_stats(@start_date, @end_date).limit(10)
      @city_stats = Visit.city_stats(@start_date, @end_date).limit(15)
      
      # 时间趋势
      @daily_stats = Visit.daily_stats(30)
      @hourly_stats = Visit.hourly_stats(Date.today)
      
      # 最近访问记录
      @recent_visits = Visit.where(visited_at: @start_date..@end_date)
                            .order(visited_at: :desc)
                            .limit(50)
                            .includes(:page_name)
    end
    
    def show
      @page_url = params[:url]
      @visit = Visit.by_page(@page_url).order(visited_at: :desc).first
      
      @page_stats = Visit.by_page(@page_url)
                         .where(visited_at: @start_date..@end_date)
                         .count
      @unique_ips = Visit.by_page(@page_url)
                        .where(visited_at: @start_date..@end_date)
                        .distinct.count(:ip_address)
      @visits = Visit.by_page(@page_url)
                    .where(visited_at: @start_date..@end_date)
                    .order(visited_at: :desc)
                    .page(params[:page])
                    .per(30)
    end
    
    private
    
    def parse_period(period)
      case period
      when 'today'
        [Time.zone.beginning_of_day, Time.zone.end_of_day]
      when 'yesterday'
        [1.day.ago.beginning_of_day, 1.day.ago.end_of_day]
      when 'week'
        [Time.zone.beginning_of_week, Time.zone.end_of_week]
      when 'month'
        [Time.zone.beginning_of_month, Time.zone.end_of_month]
      when 'year'
        [Time.zone.beginning_of_year, Time.zone.end_of_year]
      when 'all'
        [Visit.minimum(:visited_at) || Time.zone.beginning_of_year, Time.zone.end_of_day]
      else
        [Time.zone.beginning_of_day, Time.zone.end_of_day]
      end
    end
  end
end
