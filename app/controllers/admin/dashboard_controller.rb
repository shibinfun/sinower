class Admin::DashboardController < Admin::BaseController
  def index
    @users_count = User.count
    @total_skus = Sku.count
    @active_skus = Sku.where(status: 'active').count
    @messages_count = ContactMessage.count
    @warranty_inquiries_count = WarrantyInquiry.count
    @today_visits = VisitRecord.where("visit_time >= ?", Time.current.beginning_of_day).count
    @total_visits = VisitRecord.count
    
    # 诊断信息
    @storage_writable = File.writable?("/app/storage") rescue false
    @vips_installed = system("vips --version") rescue false
  end
end
