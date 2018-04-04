# frozen_string_literal: true
Decidim.configure do |config|
  config.application_name = "Decidim Hospitalet"
  config.mailer_sender    = "nocontestar@lhon-participa.cat"

  # Uncomment this lines to set your preferred locales
  config.available_locales = %i{ca es}
  config.default_locale = :ca

  if Rails.application.secrets.geocoder
    config.geocoder = {
      static_map_url: "https://image.maps.cit.api.here.com/mia/1.6/mapview",
      here_app_id: Rails.application.secrets.geocoder[:here_app_id],
      here_app_code: Rails.application.secrets.geocoder[:here_app_code]
    }
  end

  if ENV["HEROKU_APP_NAME"].present?
    config.base_uploads_path = ENV["HEROKU_APP_NAME"] + "/"
  end

  Decidim::Verifications.register_workflow(:census_authorization_handler) do |auth|
    auth.form = "CensusAuthorizationHandler"
  end
end
