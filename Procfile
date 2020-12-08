web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e ${RACK_ENV:-development} -C config/sidekiq.yml
release: bin/rails db:environment:set RAILS_ENV=production && bin/rails db:drop db:create db:schema:load
