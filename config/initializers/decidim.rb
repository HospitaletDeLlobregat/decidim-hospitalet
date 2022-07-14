# frozen_string_literal: true
Decidim.configure do |config|
  config.application_name = "Decidim Hospitalet"
  config.mailer_sender    = "nocontestar@lhon-participa.cat"

  # Uncomment this lines to set your preferred locales
  config.available_locales = %i{ca es}
  config.default_locale = :ca

  if Rails.application.secrets.geocoder
    config.maps = {
      provider: :here,
      api_key: Rails.application.secrets.maps[:api_key],
      static: { url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview" }
    }
    config.geocoder = {
      timeout: 5,
      units: :km
    }
  end

  if ENV["HEROKU_APP_NAME"].present?
    config.base_uploads_path = ENV["HEROKU_APP_NAME"] + "/"
  end

  Decidim::Verifications.register_workflow(:census_authorization_handler) do |auth|
    auth.form = "CensusAuthorizationHandler"
  end
end

# Inform Decidim about the assets folder
Decidim.register_assets_path File.expand_path("app/packs", Rails.application.root)
