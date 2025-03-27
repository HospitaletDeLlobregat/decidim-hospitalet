# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
# DECIDIM_VERSION = "0.27.4"
DECIDIM_VERSION = { github: "openpoke/decidim", branch: "0.27-backports" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-calendar", github: "openpoke/decidim-module-calendar", branch: "release/0.27-stable"
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "0.27-backports"

gem "bootsnap", "~> 1.7"

gem "deface"
gem "health_check"
gem "puma", ">= 5.0.0"
gem "rails_semantic_logger"
gem "sentry-rails"
gem "sentry-ruby"
gem "opentelemetry-sdk"
gem "opentelemetry-instrumentation-all" 
gem "opentelemetry-exporter-otlp"

group :development, :test do
  gem "byebug", platform: :mri
  gem "faker", "~> 2.14"

  gem "decidim-dev", DECIDIM_VERSION
  gem "rubocop-faker"
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "web-console"
end

group :production do
  gem "aws-sdk-s3", require: false
  gem "sidekiq"
  gem "sidekiq-cron"
end
