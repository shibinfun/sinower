module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :destroy]

    def index
      @users = User.order(created_at: :desc)
    end

    def show
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: "User was successfully deleted."
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
