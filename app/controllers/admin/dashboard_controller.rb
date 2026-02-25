class Admin::DashboardController < Admin::BaseController
  def index
    @users_count = User.count
    # 这里可以添加更多统计数据
  end
end
