class SessionsController < ApplicationController
  layout "layouts/application_user"

  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    check_save user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private
  def check_save user
    if user&.authenticate(params[:session][:password])
      handle_successful_login user
    else
      handle_failed_login
    end
  end

  def handle_failed_login
    flash[:danger] = t("login.failed")
    render :new, status: :unprocessable_entity
  end

  def handle_successful_login user
    if user.is_activated?
      handle_activated user
    else
      handle_not_activate
    end
  end

  def handle_activated user
    forwarding_url = session[:forwarding_url]
    reset_session
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    log_in(user)
    redirect_to admin_path and return if admin?

    redirect_to forwarding_url || root_url
  end

  def handle_not_activate
    message = t "activation.not_actived"
    message += t "activation.check_mail"
    flash[:warning] = message
    redirect_to root_url
  end
end
