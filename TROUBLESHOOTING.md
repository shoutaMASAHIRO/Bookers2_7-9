# Rails 開発環境トラブルシューティングまとめ (Windows環境向け)

本プロジェクトの初期セットアップ時に発生した問題と、その解決に有効だったコマンドのまとめです。

## 1. 発生した主なエラーと原因

### ① 開発環境の不整合 (Rubyバージョン)
- **原因:** `Gemfile`指定のバージョンとPCインストール済みのバージョン不一致。
- **対処:** プロジェクト設定ファイルをPC環境(3.2.10)に合わせて更新。

### ② JavaScript資産のビルド失敗 (Webpacker)
- **原因:** `node_modules`の欠如、およびNode.js v17以降のOpenSSL仕様変更によるエラー。
- **対処:** `yarn install`とOpenSSLレガシープロバイダーの有効化。

### ③ Windows特有のサーバークラッシュ
- **原因:** `Spring`やPumaの自動再起動機能がWindows上で不安定。
- **対処:** `Spring`の停止・削除、Pumaの`tmp_restart`プラグインの無効化。

### ④ システムライブラリの不足 (ImageMagick)
- **原因:** 画像リサイズ用の外部ソフトが未インストール。
- **対処:** プログラム側でリサイズ処理をバイパスし、CSSでサイズ調整。

---

## 2. 解決に有効だったコマンド集

### ■ 環境構築・依存関係
```powershell
# Gemのインストール
bundle install

# JSライブラリのインストール
yarn install
```

### ■ Webpackerのコンパイル (OpenSSLエラー対策)
```powershell
# Windows/PowerShellでレガシーモードを有効化してコンパイル
$env:NODE_OPTIONS = "--openssl-legacy-provider"
bundle exec rails webpacker:compile
```

### ■ サーバーのゾンビプロセス・PID解消
```powershell
# 3000番ポートを使用中のプロセスIDを確認
Get-NetTCPConnection -LocalPort 3000 | Select-Object OwningProcess

# 強制終了する場合 (PIDが1234の場合)
Stop-Process -Id 1234 -Force

# 起動エラーの原因となるPIDファイルを削除
Remove-Item -Path "tmp/pids/server.pid" -ErrorAction SilentlyContinue
```

### ■ 明示的なサーバー起動
```powershell
# IPとポートを指定して起動
rails s -b 127.0.0.1 -p 3000
```
