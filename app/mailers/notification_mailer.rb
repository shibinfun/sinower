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

  def admin_login_otp(user)
    @user = user
    @otp = user.login_otp
    mail(
      to: @user.email,
      subject: "SINOWER Admin Login Verification Code / 后台登录验证码"
    )
  end
end
