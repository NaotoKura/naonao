#!/bin/sh
set -e

# pidディレクトリ
mkdir -p tmp/pids
rm -f tmp/pids/server.pid

# DATABASE_URL があれば DB を準備
if [ -n "$DATABASE_URL" ]; then
  echo "DATABASE_URL detected. Preparing database..."
  bundle exec rails db:prepare
else
  echo "DATABASE_URL not set. Skipping database setup"
fi

# Puma 起動（必ず exec）
exec bundle exec puma -C config/puma.rb
