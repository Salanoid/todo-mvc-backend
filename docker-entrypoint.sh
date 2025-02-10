#!/bin/bash
set -e

rm -f tmp/pids/server.pid
bundle exec rails db:drop
bundle exec rails db:create 2>/dev/null || true
bundle exec rails db:migrate
exec "$@"
