module Admin
  class PageViewsController < ApplicationController
    layout 'admin'

    def index
      @filter_params = filter_params
      
      @page_views = PageView.recent
      @page_views = @page_views.where(page_type: @filter_params[:page_type]) if @filter_params[:page_type].present?
      @page_views = @page_views.where(ip: @filter_params[:ip]) if @filter_params[:ip].present?
      @page_views = @page_views.where(city: @filter_params[:city]) if @filter_params[:city].present?
      @page_views = @page_views.where('visited_at >= ?', @filter_params[:date_from]) if @filter_params[:date_from].present?
      @page_views = @page_views.where('visited_at <= ?', @filter_params[:date_to]) if @filter_params[:date_to].present?
      
      @page_views = @page_views.page(params[:page]).per(50)
      
      # 统计数据（基于筛选条件）
      @stats = calculate_stats(@page_views)
    end

    def show
      @page_view = PageView.find(params[:id])
    end

    private

    def filter_params
      params.permit(:page_type, :ip, :city, :date_from, :date_to)
    end

    def calculate_stats(scope = PageView.all)
      {
        total_views: scope.count,
        today_views: PageView.today.count,
        unique_ips_today: PageView.today.distinct.pluck(:ip).count,
        avg_duration: (scope.average(:duration)&.round || 0),
        top_pages: top_pages_query(scope),
        top_locations: top_locations_query(scope),
        device_breakdown: device_breakdown_query(scope),
        browser_breakdown: browser_breakdown_query(scope)
      }
    end

    def top_pages_query(scope)
      # Use a subquery to avoid GROUP BY issues with ORDER BY in PostgreSQL
      PageView.from(
        scope.select('page_type, page_id, page_name, COUNT(*) as view_count')
             .group('page_type, page_id, page_name'),
        'subquery'
      ).order('view_count DESC').limit(10)
    end

    def top_locations_query(scope)
      # Use a subquery to avoid GROUP BY issues with ORDER BY in PostgreSQL
      PageView.from(
        scope.select('city, province, country, COUNT(*) as view_count')
             .where.not(city: nil)
             .group('city, province, country'),
        'subquery'
      ).order('view_count DESC').limit(10)
    end

    def device_breakdown_query(scope)
      # 简单统计，可以在视图中展示
      all_records = scope.to_a
      devices = all_records.map { |pv| pv.device_type }.tally
      {
        desktop: devices['desktop'] || 0,
        mobile: devices['mobile'] || 0,
        tablet: devices['tablet'] || 0
      }
    end

    def browser_breakdown_query(scope)
      # 简单统计，可以在视图中展示
      all_records = scope.to_a
      browsers = all_records.map { |pv| pv.browser_name }.tally
      browsers
    end
  end
end
