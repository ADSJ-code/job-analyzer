class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  
  before_action :set_locale

  private

  def set_locale
    lang = request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(/^[a-z]{2}/).first
    
    I18n.locale = (lang == 'pt') ? :pt : :en
  end
end