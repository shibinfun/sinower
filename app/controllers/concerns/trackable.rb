module Trackable
  extend ActiveSupport::Concern
  include IpGeolocation

  included do
    before_action :track_page_view, if: -> { !current_user&.admin? }
    after_action :update_duration, if: -> { @page_view.present? }
  end

  private

  def track_page_view
    ip = extract_ip_from_request(request)
    location = lookup_ip_location(ip)
    
    @page_view = PageView.create!(
      page_type: determine_page_type,
      page_id: determine_page_id,
      page_name: determine_page_name,
      ip: ip,
      city: location[:city],
      province: location[:province],
      country: location[:country],
      user_agent: request.user_agent,
      referer: request.referer,
      session_id: session.id.to_s,
      visited_at: Time.current,
      duration: 0
    )
    
    # 在 session 中记录进入时间
    session[:page_view_start_time] = Time.current.to_i
  end

  def update_duration
    return unless @page_view && session[:page_view_start_time]
    
    duration = Time.current.to_i - session[:page_view_start_time]
    @page_view.update(duration: duration) if duration > 0
  ensure
    session[:page_view_start_time] = nil
  end

  def determine_page_type
    # 1=SKU, 2=Category, 3=Home, 4=Product List
    case controller_path
    when 'skus'
      1
    when 'categories'
      action_name == 'index' ? 4 : 2
    when 'home'
      3
    else
      0
    end
  end

  def determine_page_id
    params[:id].to_i if params[:id].present?
  end

  def determine_page_name
    case controller_path
    when 'skus'
      @sku&.name || "SKU ##{params[:id]}"
    when 'categories'
      @category&.localized_name || "Category ##{params[:id]}"
    when 'home'
      'Homepage'
    else
      "#{controller_name}##{action_name}"
    end
  end

  def extract_ip_from_request(request)
    ip = request.headers['X-Forwarded-For'].to_s.split(',').first&.strip
    ip ||= request.headers['X-Real-IP']
    ip ||= request.remote_ip
    ip
  end
end
