source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = "0.26.2"

gem "decidim", DECIDIM_VERSION
#gem "decidim-calendar", git: "https://github.com/alabs/decidim-module-calendar.git"
gem "decidim-direct_verifications"

gem "bootsnap", "~> 1.7"

gem 'uglifier'
gem 'lograge'
gem "virtus-multiparams"
gem 'deface'
gem "puma"

group :development, :test do
  gem 'byebug', platform: :mri

  gem "faker", "~> 2.18"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem "web-console"
end

group :production do
  gem 'sidekiq'
  gem 'dalli'
  gem 'rails_12factor'
  gem 'sendgrid-ruby'
  gem 'fog-aws'
  gem "sentry-rails"
  gem "sentry-ruby"
  gem 'newrelic_rpm'
end
