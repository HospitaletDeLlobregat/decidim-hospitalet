# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = "Decidim Hospitalet"
  config.mailer_sender = "nocontestar@lhon-participa.cat"
  config.force_ssl = ENV["FORCE_SSL"].present?

  # Uncomment this lines to set your preferred locales
  config.available_locales = [:ca, :es]
  config.default_locale = :ca

  config.maps = {
    provider: :here,
    api_key: Rails.application.secrets.maps[:api_key],
    static: { url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview" }
  }
  config.geocoder = {
    timeout: 5,
    units: :km
  }

  config.base_uploads_path = "#{ENV["HEROKU_APP_NAME"]}/" if ENV["HEROKU_APP_NAME"].present?

  Decidim::Verifications.register_workflow(:census_authorization_handler) do |auth|
    auth.form = "CensusAuthorizationHandler"
  end

  # Admin admin password configurations
  Rails.application.secrets.dig(:decidim, :admin_password, :strong).tap do |strong_pw|
    # When the strong password is not configured, default to true
    config.admin_password_strong = strong_pw.nil? ? true : strong_pw.present?
  end
  config.admin_password_expiration_days = Rails.application.secrets.dig(:decidim, :admin_password, :expiration_days).presence || 90
  config.admin_password_min_length = Rails.application.secrets.dig(:decidim, :admin_password, :min_length).presence || 15
  config.admin_password_repetition_times = Rails.application.secrets.dig(:decidim, :admin_password, :repetition_times).presence || 5

  # Additional optional configurations (see decidim-core/lib/decidim/core.rb)
  config.cache_key_separator = Rails.application.secrets.decidim[:cache_key_separator] if Rails.application.secrets.decidim[:cache_key_separator].present?
  config.expire_session_after = Rails.application.secrets.decidim[:expire_session_after].to_i.minutes if Rails.application.secrets.decidim[:expire_session_after].present?
  config.enable_remember_me = Rails.application.secrets.decidim[:enable_remember_me].present? unless Rails.application.secrets.decidim[:enable_remember_me] == "auto"
  if Rails.application.secrets.decidim[:session_timeout_interval].present?
    config.session_timeout_interval = Rails.application.secrets.decidim[:session_timeout_interval].to_i.seconds
  end
  config.follow_http_x_forwarded_host = Rails.application.secrets.decidim[:follow_http_x_forwarded_host].present?
  config.maximum_conversation_message_length = Rails.application.secrets.decidim[:maximum_conversation_message_length].to_i
  config.password_blacklist = Rails.application.secrets.decidim[:password_blacklist] if Rails.application.secrets.decidim[:password_blacklist].present?
  config.allow_open_redirects = Rails.application.secrets.decidim[:allow_open_redirects] if Rails.application.secrets.decidim[:allow_open_redirects].present?
end

if Decidim.module_installed? :api
  Decidim::Api.configure do |config|
    config.schema_max_per_page = Rails.application.secrets.dig(:decidim, :api, :schema_max_per_page).presence || 50
    config.schema_max_complexity = Rails.application.secrets.dig(:decidim, :api, :schema_max_complexity).presence || 5000
    config.schema_max_depth = Rails.application.secrets.dig(:decidim, :api, :schema_max_depth).presence || 15
  end
end

if Decidim.module_installed? :proposals
  Decidim::Proposals.configure do |config|
    config.similarity_threshold = Rails.application.secrets.dig(:decidim, :proposals, :similarity_threshold).presence || 0.25
    config.similarity_limit = Rails.application.secrets.dig(:decidim, :proposals, :similarity_limit).presence || 10
    config.participatory_space_highlighted_proposals_limit = Rails.application.secrets.dig(:decidim, :proposals, :participatory_space_highlighted_proposals_limit).presence || 4
    config.process_group_highlighted_proposals_limit = Rails.application.secrets.dig(:decidim, :proposals, :process_group_highlighted_proposals_limit).presence || 3
  end
end

if Decidim.module_installed? :meetings
  Decidim::Meetings.configure do |config|
    config.upcoming_meeting_notification = Rails.application.secrets.dig(:decidim, :meetings, :upcoming_meeting_notification).to_i.days
    if Rails.application.secrets.dig(:decidim, :meetings, :embeddable_services).present?
      config.embeddable_services = Rails.application.secrets.dig(:decidim, :meetings, :embeddable_services)
    end
    unless Rails.application.secrets.dig(:decidim, :meetings, :enable_proposal_linking) == "auto"
      config.enable_proposal_linking = Rails.application.secrets.dig(:decidim, :meetings, :enable_proposal_linking).present?
    end
  end
end

if Decidim.module_installed? :budgets
  Decidim::Budgets.configure do |config|
    unless Rails.application.secrets.dig(:decidim, :budgets, :enable_proposal_linking) == "auto"
      config.enable_proposal_linking = Rails.application.secrets.dig(:decidim, :budgets, :enable_proposal_linking).present?
    end
  end
end

if Decidim.module_installed? :accountability
  Decidim::Accountability.configure do |config|
    unless Rails.application.secrets.dig(:decidim, :accountability, :enable_proposal_linking) == "auto"
      config.enable_proposal_linking = Rails.application.secrets.dig(:decidim, :accountability, :enable_proposal_linking).present?
    end
  end
end

if Decidim.module_installed? :consultations
  Decidim::Consultations.configure do |config|
    config.stats_cache_expiration_time = Rails.application.secrets.dig(:decidim, :consultations, :stats_cache_expiration_time).to_i.minutes
  end
end

if Decidim.module_installed? :initiatives
  Decidim::Initiatives.configure do |config|
    unless Rails.application.secrets.dig(:decidim, :initiatives, :creation_enabled) == "auto"
      config.creation_enabled = Rails.application.secrets.dig(:decidim, :initiatives, :creation_enabled).present?
    end
    config.similarity_threshold = Rails.application.secrets.dig(:decidim, :initiatives, :similarity_threshold).presence || 0.25
    config.similarity_limit = Rails.application.secrets.dig(:decidim, :initiatives, :similarity_limit).presence || 5
    config.minimum_committee_members = Rails.application.secrets.dig(:decidim, :initiatives, :minimum_committee_members).presence || 2
    config.default_signature_time_period_length = Rails.application.secrets.dig(:decidim, :initiatives, :default_signature_time_period_length).presence || 120
    config.default_components = Rails.application.secrets.dig(:decidim, :initiatives, :default_components)
    config.first_notification_percentage = Rails.application.secrets.dig(:decidim, :initiatives, :first_notification_percentage).presence || 33
    config.second_notification_percentage = Rails.application.secrets.dig(:decidim, :initiatives, :second_notification_percentage).presence || 66
    config.stats_cache_expiration_time = Rails.application.secrets.dig(:decidim, :initiatives, :stats_cache_expiration_time).to_i.minutes
    config.max_time_in_validating_state = Rails.application.secrets.dig(:decidim, :initiatives, :max_time_in_validating_state).to_i.days
    unless Rails.application.secrets.dig(:decidim, :initiatives, :print_enabled) == "auto"
      config.print_enabled = Rails.application.secrets.dig(:decidim, :initiatives, :print_enabled).present?
    end
    config.do_not_require_authorization = Rails.application.secrets.dig(:decidim, :initiatives, :do_not_require_authorization).present?
  end
end

if Decidim.module_installed? :elections
  Decidim::Elections.configure do |config|
    config.setup_minimum_hours_before_start = Rails.application.secrets.dig(:elections, :setup_minimum_hours_before_start).presence || 3
    config.start_vote_maximum_hours_before_start = Rails.application.secrets.dig(:elections, :start_vote_maximum_hours_before_start).presence || 6
    config.voter_token_expiration_minutes = Rails.application.secrets.dig(:elections, :voter_token_expiration_minutes).presence || 120
  end

  Decidim::Votings.configure do |config|
    config.check_census_max_requests = Rails.application.secrets.dig(:elections, :votings, :check_census_max_requests).presence || 5
    config.throttling_period = Rails.application.secrets.dig(:elections, :votings, :throttling_period).to_i.minutes
  end

  Decidim::Votings::Census.configure do |config|
    config.census_access_codes_export_expiry_time = Rails.application.secrets.dig(:elections, :votings, :census, :access_codes_export_expiry_time).to_i.days
  end
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale

# Inform Decidim about the assets folder
Decidim.register_assets_path File.expand_path("app/packs", Rails.application.root)

# Verifications documents configurations (https://github.com/decidim/decidim/releases/tag/v0.27.6)
if Decidim.module_installed? :verifications
  Decidim::Verifications.configure do |config|
    config.document_types = Rails.application.secrets.dig(:verifications, :document_types).presence || %w(identification_number passport)
  end
end
