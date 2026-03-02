# Basolato + Nim Cloud Run Template

Basolato / Nim / Tailwind CSS でWebサイトを作り、Cloud Runへデプロイするためのテンプレートです。  
初回でも `./scripts/build.sh` だけで依存解決とCSSビルドまで進められるようにしています。
デフォルトページは `localStorage` で動くTodoアプリになっており、プロトタイプとしてそのまま使えます。

## 必要環境

- Nim 2.x
- curl (Tailwind standalone CLI取得用)
- Docker (Cloud Runデプロイ時)
- gcloud CLI (Cloud Runデプロイ時)

## クイックスタート

```bash
cp .env.example .env
./scripts/build.sh
./main
```

- 初回の `./scripts/build.sh` で、Basolato を固定コミットからインストールします。
- Tailwind checksum は自動解決されます（必要なら `.env` で手動固定も可能）。
- 起動後: `http://localhost:8080`

## 開発コマンド

```bash
# Tailwind CSS を1回ビルド
./scripts/tailwind.sh build

# Tailwind watch + Basolato hot reload
./scripts/dev.sh
```

`./scripts/setup.sh` も残していますが、通常は必須ではありません。  
手動で初期化したい場合のみ実行してください。

`nimble` タスク派の場合は、次も利用できます。

```bash
NIMBLE_DIR=.nimble nimble css
NIMBLE_DIR=.nimble nimble dev
```

## テンプレートを編集する場所

- ルーティング: `main.nim`
- コントローラ: `app/http/controllers`
- ページ: `app/http/views/pages`
- Tailwind入力: `src/styles/tailwind.css`
- Tailwind設定: `tailwind.config.js`

TodoアプリのUIと動作は `app/http/views/pages/home_page.nim` 内にまとまっています。
- タスク追加
- 完了/未完了トグル
- 削除
- All / Active / Completed フィルタ
- Completed一括削除

## 環境変数

`.env.example` の主な項目:

- `PROJECT_ID`: GCPプロジェクトID
- `SERVICE`: Cloud Runサービス名
- `REGION`: デプロイリージョン
- `PORT`: アプリ待受ポート（デフォルト `8080`）
- `TAILWIND_VERSION`: Tailwind standalone のバージョン（デフォルト `v3.4.17`）
- `TAILWIND_SHA256`: ローカルビルド用 checksum（未設定/プレースホルダ時は自動解決）
- `TAILWIND_SHA256_LINUX_X64`: deploy 用 checksum（未設定/プレースホルダ時は自動解決）
- `BASOLATO_REF`: Basolato の固定コミット（必要時のみ上書き）
- `SECRET_NAME`: Secret Manager のシークレット名
- `SECRET_KEY`: シークレットを初回作成/ローテーションするときだけ設定
- `SERVICE_ACCOUNT`: Cloud Run 実行サービスアカウント（未指定時はデフォルト）
- `SITE_NAME` / `SITE_URL`: TodoページのタイトルとOG系メタ情報

## Cloud Run デプロイ

```bash
sh deploy.sh
```

`deploy.sh` は次をまとめて実行します。

- `.env` をシェル評価せずに読み込み
- Artifact Registry への push
- Secret Manager の作成/更新（`SECRET_KEY` が与えられた場合）
- Cloud Run の `--set-secrets` で `SECRET_KEY` を注入してデプロイ

Tailwind checksum は自動解決されます。`SECRET_KEY` はシークレット更新不要なら省略できます。

## 生成物の扱い

以下はテンプレートに含めず、ローカル生成に統一しています。

- `logs/`
- `node_modules/`
- `.nimble/` / `nimbledeps/`
- `tools/bin/` (Tailwind CLI)
- `public/css/tailwind.css`
- 実行バイナリ (`main`)
