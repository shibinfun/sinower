class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  def admin?
    admin
  end

  def generate_login_otp!
    self.login_otp = sprintf('%06d', SecureRandom.random_number(1000000))
    self.login_otp_sent_at = Time.current
    save!
  end

  def valid_login_otp?(otp)
    return false if login_otp.blank? || otp.blank?
    return false if login_otp_sent_at < 5.minutes.ago
    login_otp == otp
  end

  def clear_login_otp!
    update!(login_otp: nil, login_otp_sent_at: nil)
  end
end
