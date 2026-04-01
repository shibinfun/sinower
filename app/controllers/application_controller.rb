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
    # 忽略后台请求和健康检查
    return if request.path.start_with?("/admin") || request.path == "/up"
    
    session_id = session.id.to_s rescue nil
    return if session_id.blank?

    # 尝试获取真实客户端 IP (处理代理服务器情况)
    # X-Forwarded-For 可能包含多个 IP，第一个通常是真实的客户端 IP
    forwarded_for = request.env['HTTP_X_FORWARDED_FOR']
    real_ip = if forwarded_for.present?
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
        visit_time: Time.current
      )
    end
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end
end
