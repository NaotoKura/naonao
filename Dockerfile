# ベースイメージ
FROM ruby:3.1.2

# 必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    postgresql-client \
    curl \
    git \
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8 && \
    rm -rf /var/lib/apt/lists/*

# Yarnのインストール
RUN npm install -g yarn

# 作業ディレクトリの設定
WORKDIR /app

# Gemfile と Gemfile.lock をコピー
COPY Gemfile Gemfile.lock ./

# Bundlerのインストールとgem依存関係のインストール
RUN gem install bundler && \
    bundle install

# package.json と yarn.lock をコピー
COPY package.json yarn.lock ./

# Node.js依存関係のインストール
RUN yarn install

# アプリケーションコードをコピー
COPY . .

# エントリーポイントスクリプトをコピーして実行権限を付与
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# エントリーポイントの設定
ENTRYPOINT ["entrypoint.sh"]

# ポート3000を公開
EXPOSE 3000

# Railsサーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]
