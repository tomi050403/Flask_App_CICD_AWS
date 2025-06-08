# ---
# cert ap-northeast
# for alb
# ---
resource "aws_acm_certificate" "cert_alb" {
  count             = var.environment == "prod" ? 1 : 0
  domain_name       = "*.${var.public_host_zone}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "${var.project}-${var.environment}-cert-alb"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_acm_certificate_validation" "cert_alb_valid" {
  count                   = var.environment == "prod" ? 1 : 0
  certificate_arn         = aws_acm_certificate.cert_alb[0].arn
  validation_record_fqdns = [for get_record in aws_route53_record.public_host_zone_cname_record : get_record.fqdn]
}

