class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  def set_locale
    # Pega o locale da URL, converte em símbolo e só aplica se estiver nos disponíveis
    if params[:locale].present? && I18n.available_locales.include?(params[:locale].to_sym)
      I18n.locale = params[:locale].to_sym
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
