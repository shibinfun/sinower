class VisitRecord < ApplicationRecord
  validates :session_id, presence: true
  
  before_validation :set_visit_time, on: :create
  after_create_commit :enqueue_geoinfo_job

  def self.cleanup_old_records(days = 7)
    where("visit_time < ?", days.days.ago).delete_all
  end

  private

  def set_visit_time
    self.visit_time ||= Time.current
  end

  def enqueue_geoinfo_job
    return if ip.blank? || ip == '127.0.0.1' || ip == '::1'
    GeocodeVisitRecordJob.perform_later(self)
  end

  public

  def device_info
    return "未知" if user_agent.blank?
    
    ua = user_agent.downcase
    if ua.include?('iphone') || ua.include?('ipad')
      "iOS 设备"
    elsif ua.include?('android')
      "Android 设备"
    elsif ua.include?('windows')
      "Windows PC"
    elsif ua.include?('macintosh')
      "Mac PC"
    elsif ua.include?('linux')
      "Linux PC"
    else
      "其他设备"
    end
  end
end
