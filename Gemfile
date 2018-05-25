source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = "0.11.1"

gem "decidim", git: "https://github.com/decidim/decidim.git", branch: "0.11-stable"

gem "passenger"
gem 'uglifier'
gem 'lograge'
gem 'faker'
gem "virtus-multiparams"
gem 'redcarpet'
gem 'emd'
gem 'deface'

group :development, :test do
  gem "decidim-dev", git: "https://github.com/decidim/decidim.git", branch: "0.11-stable"
  gem "rubocop"
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
