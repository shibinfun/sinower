class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "onboarding@resend.dev")
  layout "mailer"
  
  private
  
  def resend_enabled?
    ENV["RESEND_API_KEY"].present?
  end
end
