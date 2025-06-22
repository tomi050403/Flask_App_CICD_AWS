# Flask_App_CICD_AWS


## 概要

このリポジトリは、自作Flaskアプリケーション（[flask-app](https://github.com/tomi050403/flask-app)）を対象に、
**GitHub Actions** を用いて **CI/CDパイプライン** にて**Terraform / Ansible / Serverspec によってAWS環境への自動構築・構成検証**を実施するためのリポジトリです。

---

## ディレクトリ構成



---

## ワークフロー

| ジョブ | 処理概要 | ステップ概要（要点）| 実行条件・フロー制御 |
| ------ | -------- | --------------------- | -------------------- |
| **Terraform-Preview**  | 構文チェックおよび変更差分検証 | Terraform `init` / `validate` / `plan -detailed-exitcode`<br>→ Plan の終了コードを `outputs.TF_PLAN_EXITCODE` に保存 | 常に実行 |
| **Terraform-Deploy**   | 変更がある場合インフラデプロイ | Terrform `init`<br> → `apply -auto-approve`（コミットメッセージに `[apply]` がある時）<br>→ `state list` でリソース数カウント<br> | `needs.Terraform-Preview.outputs.TF_PLAN_EXITCODE == '2'`（差分あり）のとき実行 |
| **Ansible-App-Deploy** | EC2へのアプリデプロイ   | Inventory/Vars 書換 → SSH キー配置 → secvarsファイル,j2ファイル書換 → Ansible `setup.yml` 実行 | Terraform-Deploy 完了後かつ<br>環境毎に規定のリソース数が構築されている<br>• dev環境 **&&** TF\_STATE\_FLAG==56<br>• prod環境 **&&** TF\_STATE\_FLAG==62 |
| **ServerSpec-Check**   | 構成テスト | spec\_helper.rb 書換 → RDS Endpoint マスク → SSH キー配置 → Ruby/Bundler セットアップ → `bundle exec rake spec` | Terraform-Deploy **および** Ansible-App-Deploy 完了後に実行（needs で両方を待機）|

---

## 構成図
being/Flask_App_CICD_AWS/.github/workflows/cicd.ymlにてTF_VAR_environmentの値を変更することで構成内容を変化。

## Development
**TF_VAR_environment**を**dev**としてワークフローにpushした時の構成。<br>
![image](figure/figure_dev.png)  <br>
## Produbtion
**TF_VAR_environment**を**prod**としてワークフローにpushした時の構成。
- Developmentの構成について独自ドメインにてHTTPS化を追加。<br>
![image](figure/figure_add_prod.png)  <br>

---