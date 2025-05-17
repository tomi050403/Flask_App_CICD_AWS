# Flask_App_CICD_AWS

---

## 概要

このリポジトリは、自作Flaskアプリケーション（[flask-app](https://github.com/tomi050403/flask-app)）を対象に、
**GitHub Actions** を用いて **AWS環境へのCI/CDパイプライン** を構築するためのプロジェクトです。

---

## 目的

- インフラ構築後の継続的デリバリーを自動化し、運用効率向上を実現する
- GitHub Actionsを利用してCI/CDパイプラインを構築・実践する

---

## 構成概要

- GitHubリポジトリへのPush/PRをトリガーに動作
- Terraformで構築済みのAWSリソースを活用
- SSMパラメータストアでDB接続情報等を安全に管理

---

## 使用予定技術

| 項目           | 内容                                     |
|----------------|-----------------------------------------|
| クラウド        | AWS（ALB, EC2, IAM, SSM）|
| CI/CDツール     | GitHub Actions                         |
| IaC連携        | Terraform構築済みリソースを利用           |
| セキュリティ管理 | IAMロール、SSM SecureString             |

---

## 今後のタスク（予定）

- GitHub Actionsワークフローの設計と実装
- デプロイ後のALB経由検証ステップ追加

---

## 注意事項

- 本リポジトリは**CICD専用**です
- インフラ構成は別途（[AWS_Portfolio](https://github.com/tomi050403/AWS_Portfolio)）を参照してください
- Flaskアプリのソースコードも別リポジトリ（[flask-app](https://github.com/tomi050403/flask-app)）にあります

---

今後、CI/CDパイプライン実装の進捗に応じて順次更新していきます。
