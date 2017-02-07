# frozen_string_literal: true
Decidim.configure do |config|
  config.application_name = "Decidim Hospitalet"
  config.mailer_sender    = "lhon-participa@lhon-participa.cat"
  config.authorization_handlers = []

  # Uncomment this lines to set your preferred locales
  config.available_locales = %i{ca es}
  config.default_locale = :ca

  if Rails.application.secrets.geocoder
    config.geocoder = {
      here_app_id: Rails.application.secrets.geocoder["here_app_id"],
      here_app_code: Rails.application.secrets.geocoder["here_app_code"]
    }
  end
end
