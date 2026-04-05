class Admin::VisitRecordsController < Admin::BaseController
  def index
    @visit_records = VisitRecord.order(visit_time: :desc).page(params[:page]).per(20)
    @total_count = VisitRecord.count
    @today_count = VisitRecord.where("visit_time >= ?", 24.hours.ago).count
    @records_older_than_30_days = VisitRecord.where("visit_time < ?", 30.days.ago).count
  end

  def clean
    days = params[:days].to_i
    
    # 安全检查:至少保留7天数据
    if days < 7
      redirect_to admin_visit_records_path, alert: "为了数据安全，只能清理7天以前的数据"
      return
    end

    cutoff_time = days.days.ago
    deleted_count = VisitRecord.where("visit_time < ?", cutoff_time).delete_all
    
    redirect_to admin_visit_records_path, notice: "成功清理 #{deleted_count} 条 #{days} 天以前的访客记录"
  end
end
