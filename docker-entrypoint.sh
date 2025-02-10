#!/bin/bash
set -e

rm -f tmp/pids/server.pid
bundle exec rails db:migrate
exec "$@"
