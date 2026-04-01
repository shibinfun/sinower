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
      
      # 统计数据
      @stats = calculate_stats
    end

    def show
      @page_view = PageView.find(params[:id])
    end

    private

    def filter_params
      params.permit(:page_type, :ip, :city, :date_from, :date_to)
    end

    def calculate_stats
      {
        total_views: PageView.count,
        today_views: PageView.today.count,
        unique_ips_today: PageView.today.distinct.pluck(:ip).count,
        avg_duration: PageView.today.average(:duration)&.round || 0,
        top_pages: top_pages_query,
        top_locations: top_locations_query,
        device_breakdown: device_breakdown_query,
        browser_breakdown: browser_breakdown_query
      }
    end

    def top_pages_query
      PageView.select('page_type, page_id, page_name, COUNT(*) as view_count')
              .group(:page_type, :page_id, :page_name)
              .order('view_count DESC')
              .limit(10)
    end

    def top_locations_query
      PageView.select('city, province, country, COUNT(*) as view_count')
              .where.not(city: nil)
              .group(:city, :province, :country)
              .order('view_count DESC')
              .limit(10)
    end

    def device_breakdown_query
      # 需要在视图中计算
      {}
    end

    def browser_breakdown_query
      # 需要在视图中计算
      {}
    end
  end
end
