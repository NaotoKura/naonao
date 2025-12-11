# ベースイメージ（slimバージョンでサイズ削減）
FROM ruby:3.1.2-slim

# 必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    postgresql-client \
    curl \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Yarnのインストール
RUN npm install -g yarn --silent

# 作業ディレクトリの設定
WORKDIR /app

# Gemfile と Gemfile.lock をコピー
COPY Gemfile Gemfile.lock ./

# Bundlerのインストールとgem依存関係のインストール（本番用）
# development, testグループを除外
RUN gem install bundler -v '~> 2.3.0' && \
    bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3 && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

# package.json と yarn.lock をコピー
COPY package.json yarn.lock ./

# Node.js依存関係のインストール（本番環境のみ）
RUN yarn install --production --frozen-lockfile && \
    yarn cache clean

# アプリケーションコードをコピー
COPY . .

# アセットのプリコンパイル（本番環境用）
RUN SECRET_KEY_BASE=dummy RAILS_ENV=production bundle exec rails assets:precompile && \
    rm -rf node_modules tmp/cache

# 本番環境では不要なファイルを削除してイメージサイズを削減
RUN rm -rf \
    /app/test \
    /app/spec \
    /app/tmp/cache \
    /app/.git

# 環境変数の設定
ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true

# ポート8080を公開（Railwayのデフォルト）
EXPOSE 8080

# 非rootユーザーで実行（セキュリティ向上）
RUN useradd -m -u 1000 rails && \
    chown -R rails:rails /app
USER rails

# Railsサーバーを起動（Puma）
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
