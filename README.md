# Sample App

タスク管理、投稿管理、スケジュール管理機能を備えた多機能Webアプリケーション

## 主な機能

- **カンバンボード**: ドラッグ&ドロップ対応のタスク管理ボード
- **投稿管理**: 投稿のCRUD操作、いいね機能、ワードクラウド表示
- **スケジュール管理**: 日付ベースのスケジュール管理
- **タスク管理**: ガントチャート表示対応
- **メモ機能**: シンプルなメモ管理
- **ユーザー管理**: ユーザー認証、プロフィール管理、検索機能

## 技術スタック

### バックエンド
- **Ruby**: 3.1.2
- **Rails**: 7.0.4
- **データベース**: PostgreSQL
- **Webサーバー**: Puma

### フロントエンド
- **JavaScript**: Webpacker 3.0
- **jQuery**: 4.2.2
- **Hotwire**: Turbo Rails, Stimulus
- **SortableJS**: ドラッグ&ドロップ機能

### 主要なGem
- `bcrypt`: パスワードの安全な暗号化
- `kaminari`: ページネーション
- `discard`: ソフトデリート機能
- `activerecord-import`: 高速なバルクインサート
- `whenever`: cronジョブ管理
- `natto`: 形態素解析（MeCab連携）

## 必要な環境

### ローカル環境
- Ruby 3.1.2
- PostgreSQL
- Node.js & Yarn
- MeCab（ワードクラウド機能を使用する場合）

### Docker環境（推奨）
- Docker
- Docker Compose

## セットアップ

### Docker環境での起動（推奨）

Dockerを使用すると、環境構築が簡単で、依存関係の問題を避けられます。

#### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd sample_app
```

#### 2. Dockerコンテナのビルドと起動

```bash
# コンテナのビルドと起動
docker-compose up --build

# バックグラウンドで起動する場合
docker-compose up -d --build
```

#### 3. アプリケーションへのアクセス

ブラウザで以下のURLにアクセスしてください：
- アプリケーション: http://localhost:3000
- Webpacker Dev Server: http://localhost:3035

#### Docker環境での主なコマンド

```bash
# コンテナの起動
docker-compose up

# コンテナの停止
docker-compose down

# コンテナの再起動
docker-compose restart

# ログの確認
docker-compose logs -f web

# Railsコンソール
docker-compose exec web rails console

# マイグレーション
docker-compose exec web rails db:migrate

# テスト実行
docker-compose exec web rails test

# コンテナ内でコマンドを実行
docker-compose exec web bash
```

#### トラブルシューティング

```bash
# 全てのコンテナとボリュームを削除してクリーンアップ
docker-compose down -v

# イメージを再ビルド
docker-compose build --no-cache

# Gemやyarn依存関係の再インストール
docker-compose run --rm web bundle install
docker-compose run --rm web yarn install
```

---

### ローカル環境でのセットアップ

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd sample_app
```

### 2. 依存関係のインストール

```bash
# Ruby gems
bundle install

# JavaScript packages
yarn install
```

### 3. データベースのセットアップ

```bash
# データベースの作成
rails db:create

# マイグレーションの実行
rails db:migrate

# シードデータの投入（オプション）
rails db:seed
```

### 4. 環境変数の設定

`.env`ファイルを作成し、必要な環境変数を設定してください：

```bash
# データベース設定
DATABASE_URL=postgresql://username:password@localhost/sample_app_development

# その他の設定
RAILS_ENV=development
```

### 5. アセットのコンパイル

```bash
# Webpackerのコンパイル
rails webpacker:compile
```

## アプリケーションの起動

### 開発サーバーの起動

```bash
rails server
```

ブラウザで `http://localhost:3000` にアクセスしてください。

### Webpackerの自動コンパイル（別ターミナル）

```bash
./bin/webpack-dev-server
```

## テストの実行

```bash
# 全テストの実行
rails test

# システムテストの実行
rails test:system
```

## cronジョブの管理

`whenever` gemを使用してcronジョブを管理しています。

```bash
# cronジョブのスケジュールを確認
whenever

# cronへの登録
whenever --update-crontab

# cronから削除
whenever --clear-crontab
```

## データベース

### PostgreSQL接続情報

- **Development**: `sample_app_development`
- **Test**: `sample_app_test`
- **Production**: 環境変数 `DATABASE_URL` で設定

### 主要なモデル

- `User`: ユーザー情報
- `Board`, `Lane`, `Card`: カンバンボード関連
- `Post`, `Like`: 投稿機能
- `Schedule`: スケジュール管理
- `Task`: タスク管理（ガントチャート）
- `Memo`: メモ機能

## デプロイ

### Railwayへのデプロイ

このアプリケーションはRailwayでDockerコンテナとしてデプロイできます。

#### 1. Railwayプロジェクトの作成

1. [Railway](https://railway.app/)にログイン
2. 「New Project」をクリック
3. GitHubリポジトリを接続

#### 2. PostgreSQLデータベースの追加

1. プロジェクトダッシュボードで「New」→「Database」→「Add PostgreSQL」
2. データベースが自動的に作成され、`DATABASE_URL`環境変数が設定されます

#### 3. 環境変数の設定

Railwayのプロジェクト設定で以下の環境変数を設定：

```
RAILS_ENV=production
RACK_ENV=production
SECRET_KEY_BASE=<rails secret で生成>
RAILS_MASTER_KEY=<config/master.keyの内容>
PORT=8080
```

`SECRET_KEY_BASE`の生成方法：
```bash
rails secret
```

#### 4. デプロイ

GitHubにpushすると自動的にデプロイされます。

```bash
git add .
git commit -m "Configure for Railway deployment"
git push origin main
```

#### 5. データベースのマイグレーション

初回デプロイ後、Railwayのコンソールで：

```bash
rails db:migrate
```

#### 注意事項

- `Dockerfile`は本番環境用、`Dockerfile.dev`は開発環境用です
- Railwayは自動的に`Dockerfile`を検出してビルドします
- ポート8080がデフォルトで使用されます
- アセットは自動的にプリコンパイルされます

---

### その他の環境へのデプロイ

本番環境へのデプロイ手順：

1. 環境変数の設定（本番用DATABASE_URL、SECRET_KEY_BASE等）
2. アセットのプリコンパイル: `RAILS_ENV=production rails assets:precompile`
3. データベースのマイグレーション: `RAILS_ENV=production rails db:migrate`
4. Webサーバーの起動

## 開発時の注意事項

- マイグレーションファイルを作成した後は必ず `rails db:migrate` を実行してください
- JavaScriptやCSSを変更した場合、Webpackerの再コンパイルが必要です
- MeCabがインストールされていない場合、ワードクラウド機能は利用できません

## ライセンス

このプロジェクトは個人学習用のサンプルアプリケーションです。

## 貢献

バグ報告や機能改善の提案は、Issuesからお願いします。
