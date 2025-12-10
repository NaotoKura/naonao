# ベースイメージ
FROM ruby:3.1.2

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8 \
    git \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Yarn をインストール
RUN npm install -g yarn

# 作業ディレクトリ
WORKDIR /app

# Bundler 用ファイルのみ先にコピー
COPY Gemfile Gemfile.lock ./

# bundler インストール & gem install
RUN gem install bundler && \
    bundle install --without development test

# Node パッケージ関連をコピー
COPY package.json yarn.lock ./

# yarn install
RUN yarn install --production=false

# アプリケーション全体をコピー
COPY . .

# assets:precompile（超重要）
RUN RAILS_ENV=production bundle exec rake assets:precompile

# 環境変数
ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV PORT=8080

# ポート公開
EXPOSE 8080

RUN echo "RAILS_ENV=${RAILS_ENV}, RACK_ENV=${RACK_ENV}"

# puma を起動
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
