web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e ${RACK_ENV:-development} -c config/sidekiq.yml
