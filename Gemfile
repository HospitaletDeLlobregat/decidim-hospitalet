source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: "https://github.com/decidim/decidim" }

gem "decidim", DECIDIM_VERSION

gem "passenger"
gem 'uglifier'
gem 'lograge'
gem 'faker'
gem "virtus-multiparams"

group :development, :test do
  gem "decidim-dev", DECIDIM_VERSION
  gem 'byebug', platform: :mri
  gem "puma"
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem "rspec-rails"
end

group :production do
  gem 'sidekiq'
  gem 'dalli'
  gem 'rails_12factor'
  gem 'sendgrid-ruby'
  gem 'fog-aws'
  gem 'sentry-raven'
  gem 'newrelic_rpm'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
