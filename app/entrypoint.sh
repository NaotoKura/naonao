#!/bin/sh
set -e

mkdir -p tmp/pids
rm -f tmp/pids/server.pid

echo "Starting Rails server on port ${PORT:-8080}"

exec bundle exec rails server \
  -e production \
  -b 0.0.0.0 \
  -p ${PORT:-8080}
