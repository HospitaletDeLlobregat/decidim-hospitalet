# frozen_string_literal: true
Decidim.configure do |config|
  config.application_name = "Decidim Hospitalet"
  config.mailer_sender    = "lhonplataforma@l-h.cat"
  config.authorization_handlers = []

  # Uncomment this lines to set your preferred locales
  config.available_locales = %i{ca es}
  config.default_locale = :ca
end
