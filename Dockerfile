FROM ruby:3.0 AS builder

RUN NODE_MAJOR=16 && \
    apt-get update && apt-get upgrade -y && apt-get install -y ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn \
    build-essential \
    postgresql-client \
    libpq-dev && \
    apt-get clean

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /app

# Copy package dependencies files only to ensure maximum cache hit
COPY ./package-lock.json /app/package-lock.json
COPY ./package.json /app/package.json
COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock

RUN gem install bundler:$(grep -A 1 'BUNDLED WITH' Gemfile.lock | tail -n 1 | xargs) && \
    bundle config --local without 'development test' && \
    bundle install -j4 --retry 3 && \
    # Remove unneeded gems
    bundle clean --force && \
    # Remove unneeded files from installed gems (cache, *.o, *.c)
    rm -rf /usr/local/bundle/cache && \
    find /usr/local/bundle/ -name "*.c" -delete && \
    find /usr/local/bundle/ -name "*.o" -delete && \
    find /usr/local/bundle/ -name ".git" -exec rm -rf {} + && \
    find /usr/local/bundle/ -name ".github" -exec rm -rf {} + && \
    # whkhtmltopdf has binaries for all platforms, we don't need them once uncompressed
    rm -rf /usr/local/bundle/gems/wkhtmltopdf-binary-*/bin/*.gz && \
    # Remove additional unneded decidim files
    find /usr/local/bundle/ -name "decidim_app-design" -exec rm -rf {} + && \
    find /usr/local/bundle/ -name "spec" -exec rm -rf {} +

RUN npm ci

# copy the rest of files
COPY ./app /app/app
COPY ./bin /app/bin
COPY ./config /app/config
COPY ./db /app/db
COPY ./lib /app/lib
COPY ./packages /app/packages
COPY ./public/*.* /app/public/
COPY ./config.ru /app/config.ru
COPY ./Rakefile /app/Rakefile
COPY ./babel.config.json /app/babel.config.json
COPY ./postcss.config.js /app/postcss.config.js

# Compile assets with Webpacker or Sprockets
#
# Notes:
#   1. Executing "assets:precompile" runs "webpacker:compile", too
#   2. For an app using encrypted credentials, Rails raises a `MissingKeyError`
#      if the master key is missing. Because on CI there is no master key,
#      we hide the credentials while compiling assets (by renaming them before and after)
#
RUN mv config/credentials.yml.enc config/credentials.yml.enc.bak 2>/dev/null || true
RUN mv config/credentials config/credentials.bak 2>/dev/null || true

RUN RAILS_ENV=production \
    SECRET_KEY_BASE=dummy \
    RAILS_MASTER_KEY=dummy \
    DB_ADAPTER=nulldb \
    bundle exec rails assets:precompile

RUN mv config/credentials.yml.enc.bak config/credentials.yml.enc 2>/dev/null || true
RUN mv config/credentials.bak config/credentials 2>/dev/null || true

RUN rm -rf node_modules tmp/cache vendor/bundle test spec app/packs .git

# This image is for production env only
FROM ruby:3.0-slim AS final

RUN apt-get update && \
    apt-get install -y postgresql-client \
    imagemagick \
    curl \
    supervisor && \
    apt-get clean

EXPOSE 3000

ARG CAPROVER_GIT_COMMIT_SHA=${CAPROVER_GIT_COMMIT_SHA}
ENV APP_REVISION=${CAPROVER_GIT_COMMIT_SHA}

ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_ENV production

ARG RUN_RAILS
ARG RUN_SIDEKIQ

# Add user
RUN addgroup --system --gid 1000 app && \
    adduser --system --uid 1000 --home /app --group app

WORKDIR /app
COPY ./entrypoint.sh /app/entrypoint.sh
COPY ./supervisord.conf /etc/supervisord.conf
COPY --from=builder --chown=app:app /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder --chown=app:app /app /app

USER app
HEALTHCHECK --interval=1m --timeout=5s --start-period=30s \
    CMD (curl -sS http://localhost:3000/health_check | grep success) || exit 1

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
