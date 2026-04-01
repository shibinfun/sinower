class Admin::VisitRecordsController < Admin::BaseController
  def index
    @visit_records = VisitRecord.order(visit_time: :desc).page(params[:page]).per(20)
    @total_count = VisitRecord.count
    @today_count = VisitRecord.where("visit_time >= ?", 24.hours.ago).count
  end
end
