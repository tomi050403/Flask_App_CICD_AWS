### project settings
project     = "flask-app"             # プロジェクト名（タグやリソース名に使用）
environment = "dev"                   # 環境名（dev/stg/prodなど）
region      = "ap-northeast-1"        # 東京リージョン（必要に応じて変更）

### network settings
vpc_cidr_block  = "10.10.0.0/16"      # VPCのCIDRブロック
AZ_1            = "ap-northeast-1a"   # 利用するAZ1
AZ_1_publicsub  = "10.10.1.0/24"      # AZ1のパブリックサブネット
AZ_1_privatesub = "10.10.11.0/24"     # AZ1のプライベートサブネット
AZ_2            = "ap-northeast-1c"   # 利用するAZ2
AZ_2_publicsub  = "10.10.2.0/24"      # AZ2のパブリックサブネット
AZ_2_privatesub = "10.10.12.0/24"     # AZ2のプライベートサブネット

### security settings
ALB_from_IP = "0.0.0.0/0"     # ALBのアクセス許可元IP（CIDR形式。アプリケーション公開範囲を必要に応じて設定）

### compute settings
appsv_instance_type = "t2.micro"                # Appサーバのインスタンスタイプ
app_sv_ami          = "ami-0b28346b270c7b165"   # Appサーバ用AMI(2025年構築時点)
websv_instance_type = "t2.micro"                # Webサーバのインスタンスタイプ
web_sv_ami          = "ami-0b28346b270c7b165"   # Webサーバ用AMI(2025年構築時点)

### rds settings
rds_instance_class  = "db.t3.micro"     # RDSインスタンスタイプ
rds_username        = "admin"           # RDSの初期ユーザー名
rds_az_none_multiaz = "ap-northeast-1a" # RDSの配置AZ（RDSにて非Multi-AZの場合使用）
rds_db_name         = "flask_app"       # データベース名

### route53 settings
private_host_zone = "instance.privatelocal"   # プライベートホストゾーン名
