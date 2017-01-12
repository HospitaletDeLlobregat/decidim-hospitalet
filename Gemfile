source "https://rubygems.org"

ruby '2.3.3'

gem "decidim", git: "https://github.com/AjuntamentdeBarcelona/decidim.git"
gem "decidim_hospitalet-surveys", path: "engines/decidim_hospitalet-surveys"

gem 'puma', '~> 3.0'
gem 'uglifier', '>= 1.3.0'

gem "foundation_rails_helper", git: "https://github.com/sgruhier/foundation_rails_helper.git", tag: "df0bd8e"

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'faker', '~> 1.6.6'
end

group :production do
  gem 'rails_12factor'
  gem 'sendgrid-ruby'
  gem 'fog-aws'
  gem 'sentry-raven'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
