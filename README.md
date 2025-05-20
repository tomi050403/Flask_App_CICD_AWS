# Flask_App_CICD_AWS

---

## 概要

このリポジトリは、自作Flaskアプリケーション（[flask-app](https://github.com/tomi050403/flask-app)）を対象に、
**GitHub Actions** を用いて **CI/CDパイプライン** にて**Terraform / Ansible / Serverspec によってAWS環境への自動構築・構成検証**を実施するためのリポジトリです。

---

## 目的

- インフラ構築後の継続的デリバリーを自動化し、運用効率向上を実現する。
- GitHub Actionsを利用してCI/CDパイプラインを構築・実践する。
- 別途（[AWS_Portfolio](https://github.com/tomi050403/AWS_Portfolio)）実施している内容のCI/CD部分を実施しているものになります。

---

## ワークフロー起動条件

|トリガー種別     | 条件                                                            |
| :-------------- | :-------------------------------------------------------------- |
|push             |ブランチへの push かつ .trigger/change.txt の更新がある場合に実行|
|workflow_dispatch|GitHub UI 上からの手動実行                                       |

---

## ジョブ構成と依存関係

| ジョブ名           | 実行条件                                           | 依存関係           |
| :----------------- | -------------------------------------------------- | ------------------ |
| Terraform-Preview  | 常に実行                                           | なし               |
| Terraform-Deploy   | Terraform Plan にて差分がある場合                  | Terraform-Preview  |
| Ansible-App-Deploy | Terraform Apply 実行後のリソース数が既定の数の場合 | Terraform-Deploy   |
| ServerSpec-Check   | Ansible による構成完了後、常に実行                 | Ansible-App-Deploy |

---

## 各ジョブの処理概要

### Terraform-Preview
Terraform のセットアップと初期化
- terraform plan を実行し、差分があるかどうかを Exit Code（0: 無変更, 2: 差分あり）で判断
- Exit Code を次ジョブの実施判定として渡すため TF_PLAN_EXITCODE として出力

### Terraform-Deploy
Terraform applyによるAWS環境構築の実行
- Terraform-Preview の結果 TF_PLAN_EXITCODE == 2 の場合のみ実行
- terraform apply を commit message に [apply] が含まれている場合のみ実行
- Apply 後に terraform state list で状態ファイル中のリソース数をカウントし、TF_STATE_FLAG として出力

### Ansible-App-Deploy
Ansible Playbook によるアプリデプロイ実行
- Terraform-Deploy の TF_STATE_FLAG == 56 の場合にのみ実行（想定通りにインフラが構成されているとき）
- EC2インスタンスID取得およびSSMパラメータストアからDB情報などを取得し、inventoryファイル、varsファイルを更新

### ServerSpec-Check
アプリケーション構成後に自動で実行されるサーバテスト
- EC2 IDとRDSエンドポイント(実行ログに出力されないようmask化)を取得し、テスト設定ファイルに挿入
- Ruby環境セットアップ、Serverspec依存関係のインストール
- bundle exec rake spec により実行

#### アプリケーションサーバテスト項目
| カテゴリ               | テスト内容                                                                    |
| ---------------------- | ----------------------------------------------------------------------------- |
| パッケージ             | 必要なビルドツール・ライブラリがインストールされているか                       |
| Pyenv                  | `pyenv` がインストールされていること                                           |
| Python バージョン      | Python のバージョンが `3.12.1` であること                                      |
| Python 実行パス        | python が `pyenv` 管理下であること                                             |
| Poetry                 | `poetry` のバージョンが `1.8.4` であること                                     |
| ディレクトリ存在確認   | `flask-app` ディレクトリが存在すること                                         |
| .envファイル確認       | `.env` ファイルが存在し、必要な環境変数が記述されていること（6項目）           |
| Gunicorn プロセス      | `gunicorn` が `flaskr:app` をデーモンとして起動していること                    |
| アプリケーションポート | ポート `8000` が Listen 状態であること                                         |
| ホストIP確認           | `hostname -I` の結果に `10.10.12.*` が含まれること <br>  意図したNWセグメントに アプリケーションサーバが構築されていること     |
| RDS エンドポイント確認 | `dig` 結果が `10.10.*` または `10.20.*` のネットワークセグメントであること <br> 意図したNWセグメントに RDSが構築されていること |
#### Webサーバテスト項目
| カテゴリ           | テスト内容                                                                          |
| ------------------ | ----------------------------------------------------------------------------------- |
| Nginx パッケージ   | `nginx` がインストールされていること                                                |
| Nginx サービス     | `nginx` サービスが有効化され、起動していること                                      |
| Nginx 設定ファイル | 設定ファイルが存在し、`proxy_pass` 設定に正しいホスト名とポートが指定されていること |
| Webポート確認      | ポート `80` が Listen 状態であること                                                |
| ホスト名解決       | アプリケーションサーバ`app.dev.instance.privatelocal` が解決可能であること          |
| アプリ疎通確認     | アプリケーションが HTTP 200 を返すこと                                              |
| ホストIP確認       | `hostname -I` の結果に `10.10.11.*` が含まれること   <br>  意図したNWセグメントに webサーバが構築されていること   |

---

## ポイント
- セキュリティ情報や接続情報（例：AWS IAM Role、SSH Key、GitHub Token）は secrets にて秘匿化
- 特定の処理は コミットメッセージ(github.event.head_commit.message, '[apply]')や outputs:にて起動条件を利用して柔軟な条件制御を実現
- AnsibleおよびServerspec実行時のEC2インスタンスへの接続にてSSH over SSMを利用


---

## 注意事項

- 本リポジトリは**CICD専用**です
- インフラ構成（Terraform,Ansible）等は別途（[AWS_Portfolio](https://github.com/tomi050403/AWS_Portfolio)）をご参照ください
- Flaskアプリのソースコードも別リポジトリ（[flask-app](https://github.com/tomi050403/flask-app)）になります
