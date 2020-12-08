web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e ${RACK_ENV:-development} -C config/sidekiq.yml
release: bin/rails db:environment:set RAILS_ENV=production && bundle exec rake db:schema:load
