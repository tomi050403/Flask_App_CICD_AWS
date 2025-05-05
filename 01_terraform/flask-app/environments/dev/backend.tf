terraform {
  backend "s3" {
    bucket  = var.backend_bucket
    key     = var.backend_key
    region  = "ap-northeast-1"
  }
}
