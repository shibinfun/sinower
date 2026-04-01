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
      begin
        NotificationMailer.contact_notification(@contact_message).deliver_later
      rescue => e
        Rails.logger.error "Failed to queue contact email: #{e.message}"
      end
      redirect_to contact_path, notice: t('home.contact.success_notice', default: "Message sent successfully. We will contact you as soon as possible. / 消息已成功发送，我们会尽快与您联系。")
    else
      render :contact, status: :unprocessable_entity
    end
  end

  def warranty
    @warranty_inquiry = WarrantyInquiry.new
    @refrigeration_pdf = WarrantyPdf.refrigeration
    @cooking_pdf = WarrantyPdf.cooking
    @stainless_pdf = WarrantyPdf.stainless
    @claim_form_pdf = WarrantyPdf.claim_form
    @spare_parts_pdf = WarrantyPdf.spare_parts
  end

  def create_warranty_inquiry
    @warranty_inquiry = WarrantyInquiry.new(warranty_inquiry_params)
    if @warranty_inquiry.save
      begin
        NotificationMailer.warranty_notification(@warranty_inquiry).deliver_later
      rescue => e
        Rails.logger.error "Failed to queue warranty email: #{e.message}"
      end
      redirect_to warranty_path, notice: t('home.warranty.feedback_success', default: "Message sent successfully. We will contact you as soon as possible. / 消息已成功发送，我们会尽快与您联系。")
    else
      @refrigeration_pdf = WarrantyPdf.refrigeration
      @cooking_pdf = WarrantyPdf.cooking
      @stainless_pdf = WarrantyPdf.stainless
      @claim_form_pdf = WarrantyPdf.claim_form
      @spare_parts_pdf = WarrantyPdf.spare_parts
      render :warranty, status: :unprocessable_entity
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
