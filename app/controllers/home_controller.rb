class HomeController < ApplicationController
  def index
  end

  def all_products
    @root_categories = Category.where(parent_id: nil).includes(children: { children: { children: :skus } })
  end

  def contact
    @contact_message = ContactMessage.new
  end

  def about
  end

  def create_contact
    @contact_message = ContactMessage.new(contact_params)
    if @contact_message.save
      redirect_to contact_path, notice: t('home.contact.success_notice', default: "Message sent successfully. We will contact you as soon as possible. / 消息已成功发送，我们会尽快与您联系。")
    else
      render :contact, status: :unprocessable_entity
    end
  end

  def warranty
    @warranty_inquiry = WarrantyInquiry.new
  end

  def create_warranty_inquiry
    @warranty_inquiry = WarrantyInquiry.new(warranty_inquiry_params)
    if @warranty_inquiry.save
      redirect_to warranty_path, notice: t('home.warranty.feedback_success', default: "Message sent successfully. We will contact you as soon as possible. / 消息已成功发送，我们会尽快与您联系。")
    else
      # 简单起见，如果失败直接跳回 warranty 页面，通常这里应该处理错误信息
      redirect_to warranty_path, alert: "提交失败，请检查填写内容"
    end
  end

  private

  def contact_params
    params.require(:contact_message).permit(:name, :email, :subject, :message)
  end

  def warranty_inquiry_params
    params.require(:warranty_inquiry).permit(:subject, :product_type, :model_number, :description, :name, :phone, :email)
  end
end
