class Admin::DashboardController < Admin::BaseController
  def index
    @users_count = User.count
    @total_skus = Sku.count
    @active_skus = Sku.where(status: 'active').count
    @total_views = Sku.sum(:views)
    @messages_count = ContactMessage.count
  end
end
