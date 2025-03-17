# frozen_string_literal: true

if ENV["RORVSWILD_API_KEY"].present? && !Rails.env.test?
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
      revision: ENV.fetch("APP_REVISION", nil)
    }
  )
end
