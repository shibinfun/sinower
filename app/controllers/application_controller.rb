class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale
  before_action :track_visit

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  private

  def track_visit
    # 排除后台管理页面和静态资源/心跳检测
    return if request.path.start_with?("/admin") ||
              request.path.start_with?("/up") ||
              request.xhr? ||
              !request.format.html?

    VisitLog.create(
      ip: request.ip,
      remote_ip: request.remote_ip,
      path: request.fullpath,
      controller_name: controller_name,
      action_name: action_name,
      user_agent: request.user_agent,
      referrer: request.referrer
    )
  rescue StandardError => e
    Rails.logger.error "Failed to track visit: #{e.message}"
  end
end
