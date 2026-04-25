class HomeController < ApplicationController
  before_action :check_submission_rate_limit, only: [:create_contact, :create_warranty_inquiry]

  def index
  end

  def all_products
    @skus_by_category = Sku.where(status: 'active').includes(:category).order(position: :desc, created_at: :desc).group_by(&:category_id)
    @root_categories = Category.where(parent_id: nil).includes(children: { children: :children })
  end

  def contact
    @contact_message = ContactMessage.new
  end

  def about
  end

  def create_contact
    if params[:privacy_agreement] != "1"
      redirect_to contact_path, alert: t('home.contact.form.privacy_error')
      return
    end

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
    if params[:privacy_agreement_warranty] != "1"
      redirect_to warranty_path, alert: t('home.warranty.form.privacy_error')
      return
    end

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

  def check_submission_rate_limit
    last_submission = session[:last_submission_time]
    if last_submission.present? && Time.parse(last_submission) > 1.minute.ago
      redirect_to (action_name == 'create_contact' ? contact_path : warranty_path), 
                  alert: t('home.submission_limit', default: "You are submitting too frequently. Please try again in 1 minute. / 您提交得太频繁了，请在 1 分钟后再试。")
      return
    end
    session[:last_submission_time] = Time.current.to_s
  end

  def contact_params
    params.require(:contact_message).permit(:name, :email, :subject, :message)
  end

  def warranty_inquiry_params
    params.require(:warranty_inquiry).permit(:subject, :product_type, :model_number, :description, :name, :phone, :email)
  end
end
