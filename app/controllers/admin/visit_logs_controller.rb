class Admin::VisitLogsController < Admin::BaseController
  def index
    @total_visits = VisitLog.count
    @unique_ips = VisitLog.distinct.count(:remote_ip)
    
    # 页面浏览量排名
    @top_pages = VisitLog.group(:path).order('count_all DESC').limit(10).count
    
    # 最近访问记录
    @recent_visits = VisitLog.order(created_at: :desc).limit(50)
    
    # 按天统计浏览量 (最近7天)
    @daily_visits = VisitLog.where('created_at >= ?', 7.days.ago)
                            .group("DATE(created_at)")
                            .order("DATE(created_at) DESC")
                            .count
  end
end
