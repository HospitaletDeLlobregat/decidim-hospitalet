# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = "0.26.2"

gem "decidim", DECIDIM_VERSION
# gem "decidim-calendar", git: "https://github.com/alabs/decidim-module-calendar.git"
gem "decidim-direct_verifications"

gem "bootsnap", "~> 1.7"

gem "deface"
gem "emd"
gem "faker", "~> 2.14"
gem "lograge"
gem "puma"
gem "redcarpet"
gem "uglifier"
gem "virtus-multiparams"

group :development, :test do
  gem "byebug", platform: :mri

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
  gem "dalli"
  gem "fog-aws"
  gem "newrelic_rpm"
  gem "rails_12factor"
  gem "sendgrid-ruby"
  gem "sentry-rails"
  gem "sentry-ruby"
  gem "sidekiq"
end
