class NotificationMailer < ApplicationMailer
  default from: ENV.fetch("MAILER_FROM", "onboarding@resend.dev")

  def contact_notification(contact_message)
    @contact_message = contact_message
    recipients = ENV.fetch("CONTACT_FORM_TO", "admin@example.com").split(",")
    
    mail(
      to: recipients,
      subject: "New Contact Message: #{@contact_message.subject}"
    )
  end

  def warranty_notification(warranty_inquiry)
    @warranty_inquiry = warranty_inquiry
    recipients = ENV.fetch("WARRANTY_FORM_TO", "admin@example.com").split(",")

    mail(
      to: recipients,
      subject: "New Warranty Claim: #{@warranty_inquiry.subject}"
    )
  end

  def dealer_application_notification(dealer_application)
    @dealer_application = dealer_application
    recipients = ENV.fetch("DEALER_FORM_TO", ENV.fetch("CONTACT_FORM_TO", "admin@example.com")).split(",")

    if @dealer_application.resale_certificate.attached?
      attachments[@dealer_application.resale_certificate.filename.to_s] = @dealer_application.resale_certificate.download
    end

    mail(
      to: recipients,
      subject: "New Dealer Application: #{@dealer_application.company_name} - #{@dealer_application.contact_person}"
    )
  end
end
