# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t todo_mvc_backend .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name todo_mvc_backend todo_mvc_backend

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /todo-mvc-app

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client build-essential libpq-dev git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV BUNDLE_PATH=/gems \
    BUNDLE_BIN=/gems/bin \
    PATH="/gems/bin:$PATH"    

COPY docker-entrypoint.sh /usr/bin/
COPY Gemfile Gemfile.lock ./
COPY . .
RUN gem install bundler && bundle install
EXPOSE 3000
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bin/rails", "server", "-b", "0.0.0.0"]

