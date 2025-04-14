# frozen_string_literal: true

HealthCheck.setup do |config|
  config.standard_checks -= ["emailconf"]
end
