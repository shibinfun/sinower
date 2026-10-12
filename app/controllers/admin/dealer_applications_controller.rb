class Admin::DealerApplicationsController < Admin::BaseController
  def index
    @dealer_applications = DealerApplication.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @dealer_application = DealerApplication.find(params[:id])
  end

  def destroy
    @dealer_application = DealerApplication.find(params[:id])
    @dealer_application.destroy
    redirect_to admin_dealer_applications_path, notice: "经销商申请已成功删除。"
  end
end
