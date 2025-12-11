#!/bin/bash
set -e

# pidsディレクトリを作成
mkdir -p tmp/pids

# Rails server.pidが残っている場合は削除
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# データベースが利用可能になるまで待機
echo "Waiting for database..."
until PGPASSWORD=$DATABASE_PASSWORD psql -h "$DATABASE_HOST" -U "$DATABASE_USERNAME" -c '\q' 2>/dev/null; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done
echo "PostgreSQL is up - continuing"

# データベースのセットアップ（初回のみ）
if ! PGPASSWORD=$DATABASE_PASSWORD psql -h "$DATABASE_HOST" -U "$DATABASE_USERNAME" -lqt | cut -d \| -f 1 | grep -qw "$DATABASE_NAME"; then
  echo "Database does not exist. Creating..."
  bundle exec rails db:create
  bundle exec rails db:migrate
  echo "Database setup completed"
else
  echo "Database already exists"
  # マイグレーションの実行
  bundle exec rails db:migrate 2>/dev/null || echo "Migrations already up to date"
fi

# 渡されたコマンドを実行
exec "$@"
