# frozen_string_literal: true

if ENV["RORVSWILD_API_KEY"].present?
  env_file = Rails.root.join(".env").to_s
  if File.exist?(env_file)
    File.foreach(env_file) do |line|
      key, value = line.strip.split("=", 2)
      ENV[key] = value if key && value
    end
  end

  RorVsWild.start(
    api_key: ENV.fetch("RORVSWILD_API_KEY", nil),
    ignore_exceptions: [
      "ActionController::RoutingError",
      "ActiveRecord::RecordNotFound",
      "ActionView::MissingTemplate",
      "ActionController::InvalidCrossOriginRequest",
      "ActionController::InvalidAuthenticityToken"
    ],
    deployment: {
      deployment: {
        revision: ENV.fetch("REVISION", ENV.fetch("APP_REVISION", ENV.fetch("HOSTNAME", nil))),
        author: ENV.fetch("AUTHOR", nil),
        description: ENV.fetch("DESCRIPTION", nil),
        email: ENV.fetch("EMAIL", nil)
      }
    }
  )
end
