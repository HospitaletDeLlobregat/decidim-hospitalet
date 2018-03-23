source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "0.9.2"
gem "decidim_hospitalet-surveys", path: "decidim_hospitalet-surveys"

gem "passenger"
gem 'uglifier'
gem 'lograge'
gem 'faker'
gem "virtus-multiparams"

group :development, :test do
  gem "decidim-dev"
  gem 'byebug', platform: :mri
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
