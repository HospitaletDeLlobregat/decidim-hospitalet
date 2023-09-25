# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
# DECIDIM_VERSION = "0.27.4"
DECIDIM_VERSION = { github: "decidim/decidim", tag: "release/0.27-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-calendar", github: "openpoke/decidim-module-calendar"
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome"
gem "decidim-direct_verifications", github: "platoniq/decidim-verifications-direct_verifications"

gem "bootsnap", "~> 1.7"

gem "deface"
gem "emd"
gem "lograge"
gem "puma", ">= 5.0.0"
gem "redcarpet"
gem "uglifier"

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
  gem "dalli"
  gem "fog-aws"
  gem "newrelic_rpm"
  gem "rails_12factor"
  gem "sendgrid-ruby"
  gem "sentry-rails"
  gem "sentry-ruby"
  gem "sidekiq"
end
