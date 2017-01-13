# frozen_string_literal: true
Decidim.configure do |config|
  config.application_name = "Decidim Hospitalet"
  config.mailer_sender    = "info@codegram.com"
  config.authorization_handlers = []

  # Uncomment this lines to set your preferred locales
  # config.available_locales = %{en ca es}
end
