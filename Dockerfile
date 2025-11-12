# syntax=docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.3
FROM ruby:$RUBY_VERSION-slim AS base

LABEL fly_launch_runtime="rails"

# Rails app lives here
WORKDIR /rails
ENV RAILS_ENV="production" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libvips \
    pkg-config

# Install node
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    xz-utils && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install --no-install-recommends -y nodejs

# Install JavaScript dependencies
RUN npm install -g yarn

# Install gems
FROM base AS build
ARG BUILD_COMMAND="bin/rails assets:precompile"
ARG CLEAN_COMMAND="bin/rails assets:clean"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    pkg-config

# Install gems
COPY Gemfile Gemfile.lock ./
# CORREÇÃO AQUI: Rodamos o 'update' antes do 'install'
RUN bundle update net-pop && bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY README.md .  # Linha do cache buster
COPY . .

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# WORKAROUND: Comentamos esta linha para evitar o crash do ActionCable
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final image
FROM base
ARG CLEAN_COMMAND="bin/rails assets:clean"
ARG SECRET_KEY_BASE

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libvips \
    postgresql-client

# Copy built artifacts
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the files we need
RUN groupadd --system --gid 1000 rails && \
    useradd --system --uid 1000 --gid rails rails && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# ENTRYPOINT padrão foi REMOVIDO
# Start the server by default, this can be overwritten at runtime
CMD ["bin/rails", "server"]