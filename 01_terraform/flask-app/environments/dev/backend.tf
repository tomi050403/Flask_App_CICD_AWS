terraform {
  backend "s3" {
    bucket  = "tomi050403-terraform-tfstate-bucket"
    key     = "flask-app/dev/terraform.tfstate"
    region  = "ap-northeast-1"
  }
}