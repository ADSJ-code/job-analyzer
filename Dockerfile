ARG RUBY_VERSION=3.3.3
FROM ruby:$RUBY_VERSION-slim AS base
LABEL fly_launch_runtime="rails"
WORKDIR /rails
ENV RAILS_ENV="production" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libvips \
    pkg-config

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    xz-utils && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install --no-install-recommends -y nodejs
RUN npm install -g yarn

FROM base AS build
ARG BUILD_COMMAND="bin/rails assets:precompile"
ARG CLEAN_COMMAND="bin/rails assets:clean"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    pkg-config

COPY Gemfile Gemfile.lock ./
RUN bundle update net-pop && bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY README.md ./
COPY . ./

FROM base
ARG CLEAN_COMMAND="bin/rails assets:clean"
ARG SECRET_KEY_BASE

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libvips

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd --system --uid 1000 --gid rails rails && \
    chown -R rails:rails db log storage tmp

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

USER rails:rails

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bin/rails", "server"]