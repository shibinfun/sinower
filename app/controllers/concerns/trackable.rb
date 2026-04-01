module Trackable
  extend ActiveSupport::Concern

  included do
    after_action :track_visit, if: -> { request.get? && !request.xhr? }
  end

  private

  def track_visit
    # 跳过管理员、本地请求、健康检查
    return if skip_tracking?
    
    page_name = extract_page_name
    page_url = request.path
    
    # 异步记录访问（生产环境可用 Sidekiq/DelayedJob）
    Visit.record_visit(page_name, page_url, request)
  rescue => e
    Rails.logger.error "Tracking failed: #{e.message}"
  end
  
  def skip_tracking?
    # 跳过管理员后台
    request.path.start_with?('/admin') ||
      # 跳过资源文件
      request.path.match?(/\.(css|js|png|jpg|gif|svg|ico|woff|woff2|ttf|eot)/i) ||
      # 跳过健康检查
      request.path == '/up' ||
      # 跳过机器人（简单判断）
      request.user_agent.to_s.match?(/bot|crawler|spider|slurp/i)
  end
  
  def extract_page_name
    # 从路径提取页面名称
    path = request.path
    controller_name = params[:controller]&.titleize || 'Unknown'
    action_name = params[:action]&.humanize || 'Show'
    
    "#{controller_name} - #{action_name}"
  end
end
