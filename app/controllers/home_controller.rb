class HomeController < ApplicationController
  before_action :check_submission_rate_limit, only: [:create_contact, :create_warranty_inquiry, :create_dealer_application]

  def index
  end

  def robots
    robots_content = Setting.get('robots_txt', "User-agent: *\nAllow: /")
    render plain: robots_content
  end

  def sitemap
    sitemap_content = Setting.get('sitemap', '')
    if sitemap_content.present?
      render xml: sitemap_content
    else
      respond_to do |format|
        format.xml { render template: 'home/sitemap' }
        format.any { render template: 'home/sitemap', content_type: 'application/xml' }
      end
    end
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

  def dealer
    @dealer_application = DealerApplication.new
  end

  def create_dealer_application
    if params[:privacy_agreement_dealer] != "1"
      redirect_to dealer_path, alert: t('home.dealer.form.privacy_error', default: "Please agree to the privacy policy / 请同意隐私政策")
      return
    end

    @dealer_application = DealerApplication.new(dealer_application_params)
    if @dealer_application.save
      begin
        NotificationMailer.dealer_application_notification(@dealer_application).deliver_later
      rescue => e
        Rails.logger.error "Failed to queue dealer application email: #{e.message}"
      end
      redirect_to dealer_path, notice: t('home.dealer.feedback_success', default: "Application submitted successfully! Our team will contact you shortly. / 经销商申请提交成功！我们将尽快与您联系。")
    else
      render :dealer, status: :unprocessable_entity
    end
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
      redirect_path = case action_name
                      when 'create_contact' then contact_path
                      when 'create_dealer_application' then dealer_path
                      else warranty_path
                      end
      redirect_to redirect_path, 
                  alert: t('home.submission_limit', default: "You are submitting too frequently. Please try again in 1 minute. / 您提交得太频繁了，请在 1 分钟后再试。")
      return
    end
    session[:last_submission_time] = Time.current.to_s
  end

  def contact_params
    params.require(:contact_message).permit(:name, :email, :subject, :message)
  end

  def dealer_application_params
    params.require(:dealer_application).permit(
      :company_name,
      :contact_person,
      :email,
      :phone,
      :address,
      :website,
      :business_type,
      :business_type_other,
      :annual_purchase_volume,
      :product_categories_other,
      :comments,
      :resale_certificate,
      product_categories: []
    )
  end

  def warranty_inquiry_params
    params.require(:warranty_inquiry).permit(:subject, :product_type, :model_number, :description, :name, :phone, :email)
  end
end
