class Admin::WarrantyInquiriesController < Admin::BaseController
  def index
    @warranty_inquiries = WarrantyInquiry.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @warranty_inquiry = WarrantyInquiry.find(params[:id])
  end

  def destroy
    @warranty_inquiry = WarrantyInquiry.find(params[:id])
    @warranty_inquiry.destroy
    redirect_to admin_warranty_inquiries_path, notice: "反馈信息已成功删除。"
  end
end
