class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    
    if resource.admin?
      # If it's an admin, we don't sign in yet. 
      # We sign out first because warden.authenticate! might have already signed them in partially
      sign_out(resource_name)
      
      # Generate and send OTP
      resource.generate_login_otp!
      NotificationMailer.admin_login_otp(resource).deliver_later
      
      # Store user id in session for the second step
      session[:otp_user_id] = resource.id
      session[:otp_remember_me] = params[:user][:remember_me] == '1'
      
      redirect_to otp_verification_path
    else
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  def otp_verification
    @user_id = session[:otp_user_id]
    if @user_id.blank?
      redirect_to new_user_session_path, alert: "Session expired, please login again."
      return
    end
    render 'devise/sessions/otp_verification'
  end

  def verify_otp
    user_id = session[:otp_user_id]
    otp = params[:otp]
    
    if user_id.blank? || otp.blank?
      redirect_to new_user_session_path, alert: "Invalid request."
      return
    end

    user = User.find(user_id)
    if user.valid_login_otp?(otp)
      user.clear_login_otp!
      sign_in(:user, user)
      
      # Handle remember me
      if session[:otp_remember_me]
        user.remember_me!
      end

      session.delete(:otp_user_id)
      session.delete(:otp_remember_me)

      flash[:notice] = "Signed in successfully."
      redirect_to admin_root_path
    else
      flash.now[:alert] = "Invalid or expired verification code."
      render :otp_verification, status: :unprocessable_entity
    end
  end

  def resend_otp
    user_id = session[:otp_user_id]
    if user_id.present?
      user = User.find(user_id)
      user.generate_login_otp!
      NotificationMailer.admin_login_otp(user).deliver_later
      flash[:notice] = "Verification code resent."
    end
    redirect_to otp_verification_path
  end
end