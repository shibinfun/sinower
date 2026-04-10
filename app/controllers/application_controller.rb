class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale
  before_action :track_visitor

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  private

  def track_visitor
    # 忽略健康检查
    path = request.path
    return if path == "/up"
    
    # 确保 session 加载 (Rails 7/8 中 session 可能是惰性加载的)
    session[:loaded] = true if session.id.nil?
    session_id = session.id.to_s
    return if session_id.blank?

    # 尝试获取真实客户端 IP (处理代理服务器情况)
    # 优先获取 X-Forwarded-For，它是大多数反向代理使用的标准头
    forwarded_for = request.env['HTTP_X_FORWARDED_FOR']
    real_ip = if forwarded_for.present?
                # 取第一个（原始客户端）并进行基本的格式检查
                forwarded_for.split(',').first&.strip
              else
                request.env['HTTP_X_REAL_IP'] || request.remote_ip
              end

    last_visit = VisitRecord.where(session_id: session_id)
                            .where("visit_time > ?", 3.hours.ago)
                            .order(visit_time: :desc)
                            .first

    if last_visit.nil?
      VisitRecord.create(
        session_id: session_id,
        ip: real_ip,
        user_agent: request.user_agent,
        visit_time: Time.current,
        path: path
      )
    end
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end
end
