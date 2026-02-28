class Admin::ContactMessagesController < Admin::BaseController
  def index
    @contact_messages = ContactMessage.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @contact_message = ContactMessage.find(params[:id])
  end

  def destroy
    @contact_message = ContactMessage.find(params[:id])
    @contact_message.destroy
    redirect_to admin_contact_messages_path, notice: "消息已成功删除。"
  end
end
