class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ApplicationHelper
  include SessionsHelper
  include ApplicationHelper

  before_action :set_locale

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def check_admin_role
    return if admin?

    flash[:danger] = t "admin.forbidden"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "login.not_login"
    store_location
    redirect_to login_path
  end

  def load_football_pitch
    @football_pitch = FootballPitch.find_by(id: params[:football_pitch_id])
    return if @football_pitch

    flash[:error] = t("football_pitch.not_found")
    redirect_to root_path
  end
end
